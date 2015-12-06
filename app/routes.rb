require 'sinatra'
require 'sinatra/cross_origin'

require 'json'
require 'yaml'

require 'mumukit/auth'

require_relative '../lib/content_server'

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
    GitIo::Bot.from_env
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

error GuideNotFoundError do
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
  LanguageCollection.all.as_json
end


get '/guides' do
  GuideCollection.all.as_json
end

get '/guides/writable' do
  GuideCollection.allowed(grant).as_json
end

get '/guides/:organization/:repository/raw' do
  GuideCollection.find_by_slug(params['organization'], params['repository']).raw
end

get '/guides/:organization/:repository' do
  GuideCollection.find_by_slug(params['organization'], params['repository']).as_json
end

post '/guides' do
  with_json_body do |body|
    slug = body['slug']
    protect! slug

    GuideCollection.upsert_by_slug(slug, body).tap do
      GitIo::Operation::Export.new(GitIo::Guide.new(body), bot).run!
    end
  end
end

post '/guides/import/:organization/:name' do
  repo = GitIo::Repo.new(params[:organization], params[:name])
  GitIo::Operation::Import.new(bot, repo).run!
end


