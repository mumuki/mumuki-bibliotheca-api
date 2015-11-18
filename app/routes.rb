require 'sinatra'

require 'json'
require 'yaml'

require 'mumukit/auth'

require_relative '../lib/content_server'

helpers do
  def with_json_body
    yield JSON.parse(request.body.read)
  rescue JSON::ParserError => e
    error 400
  end

  def protect!(slug)
    Mumukit::Auth::Token.decode(headers['MUMUKI_AUTH_TOKEN']).grant.protect! slug
  end
end

before do
  content_type 'application/json'
end

after do
  response.body = JSON.dump(response.body)
end

get '/guides/:id/raw' do
  GuideCollection.find(params['id']).raw
end

get '/guides/:id' do
  GuideCollection.find(params['id'])
end

get '/guides/:organization/:repository/raw' do
  GuideCollection.find_by_slug(params['organization'], params['repository']).raw
end

get '/guides/:organization/:repository' do
  GuideCollection.find_by_slug(params['organization'], params['repository'])
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


