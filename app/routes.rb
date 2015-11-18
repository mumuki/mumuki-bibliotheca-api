require 'sinatra'

require 'json'
require 'yaml'

require 'mumukit/auth'

require_relative '../lib/content_server'

module Mumukit::Auth
  class InvalidTokenError < StandardError
  end

  class UnauthorizedAccessError < StandardError
  end
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
  rescue JWT::DecodeError => e
    raise Mumukit::Auth::InvalidTokenError.new(e)
  end

  def protect!(slug)
    grant.protect! slug
  rescue RuntimeError => e
    raise Mumukit::Auth::UnauthorizedAccessError.new(e)
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

error JSON::ParserError do
  halt 400
end

get '/guides' do
  {guides: GuideCollection.all.as_json(only: [:id, :name])}
end

get '/guides/writable' do
  {guides: GuideCollection.all.select { |it| grant.allows? it['github_repository'] }.as_json(only: [:id, :name])}
end

get '/guides/:id/raw' do
  GuideCollection.find(params['id']).raw
end

get '/guides/:id' do
  GuideCollection.find(params['id']).as_json
end

get '/guides/:organization/:repository/raw' do
  GuideCollection.find_by_slug(params['organization'], params['repository']).raw
end

get '/guides/:organization/:repository' do
  GuideCollection.find_by_slug(params['organization'], params['repository']).as_json
end

post '/guides' do
  with_json_body do |body|
    protect! body['github_repository']

    GuideCollection.insert(body)
  end
end

put '/guides/:id' do
  with_json_body do |body|
    protect! body['github_repository']

    GuideCollection.update(params[:id], body)
  end
end

post '/guides/import/:organization/:name' do
  repo = GitIo::Repo.new(params[:organization], params[:name])
  guide = GitIo::Operation::Import.new(GitIo::Bot.from_env, repo, guides).run!
  guide
end


