require 'sinatra'
require 'sinatra/cross_origin'

require 'json'
require 'yaml'

require 'mumukit/auth'

require_relative '../lib/bibliotheca'

configure do
  enable :cross_origin

  Mongo::Logger.logger       = ::Logger.new('mongo.log')
end

helpers do
  def with_json_body
    yield JSON.parse(request.body.read)
  end

  def auth_token
    env['HTTP_X_MUMUKI_AUTH_TOKEN']
  end

  def grant
    @grant ||= Mumukit::Auth::Token.decode(auth_token).grant
  end

  def bot
    Bibliotheca::Bot.from_env
  end

  def protect!(slug)
    grant.protect! slug
  end
end

before do
  content_type 'application/json'
end

after do
  error_message = env['sinatra.error']
  if error_message.blank?
    response.body = response.body.to_json
  else
    response.body = {message: env['sinatra.error'].message}.to_json
  end
end

error Mumukit::Auth::InvalidTokenError do
  halt 412
end

error Mumukit::Auth::UnauthorizedAccessError do
  halt 403
end

error Bibliotheca::Collection::GuideNotFoundError do
  halt 404
end

error JSON::ParserError do
  halt 400
end

options '*' do
  response.headers['Allow'] = 'HEAD,GET,PUT,POST,DELETE,OPTIONS'
  response.headers['Access-Control-Allow-Headers'] = 'X-Mumuki-Auth-Token, X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'
  200
end

get '/languages' do
  Bibliotheca::Collection::Languages.all.as_json
end


get '/guides' do
  Bibliotheca::Collection::Guides.all.as_json
end

get '/guides/writable' do
  Bibliotheca::Collection::Guides.allowed(grant).as_json
end

get '/guides/:organization/:repository/raw' do
  Bibliotheca::Collection::Guides.find_by_slug(params['organization'], params['repository']).raw
end

get '/guides/:organization/:repository' do
  Bibliotheca::Collection::Guides.find_by_slug(params['organization'], params['repository']).as_json
end

post '/guides' do
  with_json_body do |body|
    slug = body['slug']
    protect! slug

    Bibliotheca::Collection::Guides.upsert_by_slug(slug, body).tap do
      Bibliotheca::IO::Export.new(Bibliotheca::Guide.new(body), bot).run!
    end
  end
end

post '/guides/import/:organization/:name' do
  repo = Bibliotheca::Repo.new(params[:organization], params[:name])
  Bibliotheca::IO::Import.new(bot, repo).run!
end


