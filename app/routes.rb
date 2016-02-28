require 'mumukit/service/routes'

require_relative '../lib/bibliotheca'

configure do
  set :app_name, 'bibliotheca'
end

helpers do
  def bot
    Bibliotheca::Bot.from_env
  end

  def subject
    Bibliotheca::Collection::Guides.find(params[:id])
  end

  def upsert!(document_class, collection_class, export_class)
    protect!
    document = document_class.new(json_body)

    collection_class.upsert_by_slug(repo.slug, document).tap do
      export_class.new(document, bot).run! if bot.authenticated?
    end
  end
end

error Bibliotheca::Collection::ExerciseNotFoundError do
  halt 404
end

error Bibliotheca::IO::OrganizationNotFoundError do
  halt 404
end

get '/languages' do
  Bibliotheca::Collection::Languages.all.as_json
end

get '/guides' do
  Bibliotheca::Collection::Guides.all.as_json
end

get '/books' do
  Bibliotheca::Collection::Books.all.as_json
end

get '/guides/writable' do
  Bibliotheca::Collection::Guides.allowed(permissions).as_json
end

get '/guides/:id/raw' do
  Bibliotheca::Collection::Guides.find(params['id']).raw
end

get '/guides/:id' do
  Bibliotheca::Collection::Guides.find(params['id']).as_json
end

get '/guides/:guide_id/exercises/:exercise_id/test' do
  Bibliotheca::Collection::Guides.find(params['guide_id']).run_tests(params['exercise_id'].to_i).as_json
end

delete '/guides/:id' do
  protect!
  Bibliotheca::Collection::Guides.delete!(params['id'])
  {}
end

get '/guides/:organization/:repository/raw' do
  Bibliotheca::Collection::Guides.find_by_slug(slug.to_s).raw
end

get '/guides/:organization/:repository' do
  Bibliotheca::Collection::Guides.find_by_slug(slug.to_s).as_json
end

post '/guides' do
  upsert! Bibliotheca::Guide, Bibliotheca::Collection::Guides, Bibliotheca::IO::GuideExport
end

post '/books' do
  upsert! Bibliotheca::Book, Bibliotheca::Collection::Books, Bibliotheca::IO::BookExport
end

post '/guides/import/:organization/:repository' do
  Bibliotheca::IO::GuideImport.new(bot, slug).run!
end

post '/books/import/:organization/:repository' do
  Bibliotheca::IO::BookImport.new(bot, slug).run!
end

