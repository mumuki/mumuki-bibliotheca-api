require 'sinatra'

require 'json'
require 'yaml'
require 'active_support/all'

require_relative '../lib/content_server'


helpers do
  def with_json_body
    yield JSON.parse(request.body.read)
  rescue JSON::ParserError => e
    error 400
  end
end

before do
  content_type 'application/json'
end

get '/guides/:id/raw' do
  GuideCollection.find(params['id']).raw.to_json
end

get '/guides/:id' do
  GuideCollection.find(params['id']).to_json
end

get '/guides/:organization/:repository/raw' do
  GuideCollection.find_by_slug(params['organization'], params['repository']).raw.to_json
end

get '/guides/:organization/:repository' do
  GuideCollection.find_by_slug(params['organization'], params['repository']).to_json
end

post '/guides' do
  with_json_body do |body|
    GuideCollection.insert(body).to_json
  end
end

put '/guides/:id' do
  with_json_body do |body|
    GuideCollection.update(params[:id], body).to_json
  end
end

post '/guides/import/:organization/:name' do
  repo = GitIo::Repo.new(params[:organization], params[:name])
  guide = GitIo::Operation::Import.new(GitIo::Bot.from_env, repo, guides).run!

  guide.to_json
end


