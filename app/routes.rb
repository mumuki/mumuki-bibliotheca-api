require 'mumukit/content_type'
require 'mumukit/service/routes'

require_relative './session_store'
require_relative './omniauth'
require_relative '../lib/bibliotheca'

configure do
  set :app_name, 'bibliotheca'
  set :static, true
  set :public_folder, 'public'
end

Mumukit::Login.configure_login_routes! self

helpers do
  Mumukit::Login.configure_controller! self
  Mumukit::Login.configure_login_controller! self
end

before do
  I18n.locale = 'en' #TODO: Remove hardcoded locale
end

helpers do
  def authenticate!
    halt 401 unless current_user?
  end

  def authorization_slug
    slug
  end

  def bot
    Bibliotheca::Bot.from_env
  end

  def subject
    Bibliotheca::Collection::Guides.find(params[:id])
  end

  def login_settings
    Mumukit::Login::Settings.new Mumukit::Login::Settings.login_methods #TODO: Get login methods from base organization
  end

  def route_slug_parts
    [params[:organization], params[:repository]].compact
  end

  def upsert!(document_class, collection_class, export_class = nil)
    authorize! :writer
    document = document_class.new(json_body)
    exporting export_class, document: document, bot: bot, author_email: current_user.email do
      collection_class.upsert_by_slug!(slug.to_s, document)
    end.tap do
      Mumukit::Nuntius.notify_content_change_event! document_class, slug
    end
  end

  def exporting(export_class, options={}, &block)
    block.call.tap do
      export_class&.new(options.merge(slug: slug))&.run!
    end
  end

  def fork!(collection_class)
    authorize! :writer
    destination = json_body['organization']
    collection_class.find_by_slug!(slug.to_s).fork_to!(destination, bot).as_json
  end
end

error Bibliotheca::Collection::ExerciseNotFoundError do
  halt 404
end

error Bibliotheca::Collection::GuideAlreadyExists do
  halt 400
end

error Bibliotheca::IO::OrganizationNotFoundError do
  halt 404
end

post '/markdown' do
  {markdown: Mumukit::ContentType::Markdown.to_html(json_body['markdown'])}
end

post '/markdowns' do
  json_body.with_indifferent_access.tap do |guide|
    guide[:exercises].each do |exercise|
      exercise[:description] = Mumukit::ContentType::Markdown.to_html(exercise[:description])
    end
  end
end

post '/gists' do
  bot.upload_gist!(json_body['content'], json_body['extension']).as_json
end

get '/permissions' do
  authenticate!

  {permissions: current_user.permissions}
end


require_relative './routes/organization'
require_relative './routes/languages'
require_relative './routes/guides'
require_relative './routes/books'
require_relative './routes/topics'
