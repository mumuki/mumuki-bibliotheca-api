require 'sinatra'
require 'sinatra/cross_origin'

require 'json'
require 'yaml'
require 'rest-client'

require 'mumukit/auth'

require_relative '../lib/bibliotheca'

configure do
  enable :cross_origin
  set :allow_methods, [:get, :put, :post, :options, :delete]
  set :show_exceptions, false

  Mongo::Logger.logger = ::Logger.new('mongo.log')
end

helpers do
  def json_body
    @json_body ||= JSON.parse(request.body.read) rescue nil
  end

  def permissions
    token = Mumukit::Auth::Token.decode_header(authorization_header)
    token.verify_client!
    @permissions ||= token.permissions 'bibliotheca'
  end

  def authorization_header
    env['HTTP_AUTHORIZATION']
  end

  def bot
    Bibliotheca::Bot.from_env
  end

  def protect!
    permissions.protect! repo.slug
  end

  def upsert!(document_class, collection_class, export_class)
    protect!
    document = document_class.new(json_body)

    collection_class.upsert_by_slug(repo.slug, document).tap do
      export_class.new(document, bot).run! if bot.authenticated?
    end
  end

  def repo
    if params[:organization] && params[:repository]
      Bibliotheca::Repo.new(params[:organization], params[:repository])
    elsif params[:id]
      Bibliotheca::Repo.from_slug(Bibliotheca::Collection::Guides.find(params[:id]).slug)
    elsif json_body
      Bibliotheca::Repo.from_slug(json_body['slug'])
    else
      raise Bibliotheca::InvalidSlugFormatError.new('Slug not available')
    end
  end
end

before do
  content_type 'application/json', 'charset' => 'utf-8'
end

after do
  error_message = env['sinatra.error']
  if error_message.blank?
    response.body = response.body.to_json
  else
    response.body = {message: env['sinatra.error'].message}.to_json
  end
end

error JSON::ParserError do
  halt 400
end

error Mumukit::Auth::InvalidTokenError do
  halt 400
end

error Bibliotheca::InvalidSlugFormatError do
  halt 400
end

error Mumukit::Service::DocumentValidationError do
  halt 400
end

error Mumukit::Auth::UnauthorizedAccessError do
  halt 403
end

error Mumukit::Service::DocumentNotFoundError do
  halt 404
end

error Bibliotheca::Collection::ExerciseNotFoundError do
  halt 404
end

error Bibliotheca::IO::OrganizationNotFoundError do
  halt 404
end

options '*' do
  response.headers['Allow'] = settings.allow_methods.map { |it| it.to_s.upcase }.join(',')
  response.headers['Access-Control-Allow-Headers'] = 'X-Mumuki-Auth-Token, X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, Authorization'
  200
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
  Bibliotheca::Collection::Guides.find_by_slug(repo.slug).raw
end

get '/guides/:organization/:repository' do
  Bibliotheca::Collection::Guides.find_by_slug(repo.slug).as_json
end

post '/guides' do
  upsert! Bibliotheca::Guide, Bibliotheca::Collection::Guides, Bibliotheca::IO::GuideExport
end

post '/books' do
  upsert! Bibliotheca::Book, Bibliotheca::Collection::Books, Bibliotheca::IO::BookExport
end

post '/guides/import/:organization/:repository' do
  Bibliotheca::IO::GuideImport.new(bot, repo).run!
end

post '/books/import/:organization/:repository' do
  Bibliotheca::IO::BookImport.new(bot, repo).run!
end

