require 'mumukit/service/routes'
require 'mumukit/service/routes/auth'

require_relative '../lib/bibliotheca'

configure do
  set :app_name, 'bibliotheca'
end


class Mumukit::Auth::Token
  def email
    jwt['email']
  end
end

helpers do
  def bot
    Bibliotheca::Bot.from_env
  end

  def subject
    Bibliotheca::Collection::Guides.find(params[:id])
  end

  def route_slug_parts
    [params[:organization], params[:repository]].compact
  end

  def upsert!(document_class, collection_class, export_class)
    protect!
    document = document_class.new(json_body)

    collection_class.upsert_by_slug(slug.to_s, document).tap do
      export_class.new(document, bot, token.email).run! if bot.authenticated?
    end
  end
end

error Bibliotheca::Collection::ExerciseNotFoundError do
  halt 404
end

error Bibliotheca::IO::OrganizationNotFoundError do
  halt 404
end

require_relative './routes/languages'
require_relative './routes/guides'
require_relative './routes/books'
