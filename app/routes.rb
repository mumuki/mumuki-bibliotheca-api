require 'sinatra'
require 'mongo'
require 'securerandom'
require 'json'
require 'json/ext'
require_relative '../lib/git_io'

configure do
  db = Mongo::Client.new(['127.0.0.1:27017'], :database => 'content')
  set :db, db
end

helpers do
  def guides
    settings.db[:guides]
  end

  def new_id
    SecureRandom.hex(8)
  end

  def with_json_body
    yield JSON.parse(request.body.read)
  rescue JSON::ParserError => e
    error 400
  end
end

get '/guides/:id/raw' do
  guides.find(id: params['id']).projection(_id: 0).to_a.first.to_json
end

get '/guides/:id' do
  guides.find(id: params['id']).projection(_id: 0).map {|it| GitIo::Guide.new(it) }.to_a.first.to_json
end

post '/guides' do
  with_json_body do |body|
    id = {id: new_id}
    guides.insert_one body.merge(id)
    id.to_json
  end
end

put '/guides/:id' do
  with_json_body do |body|
    id = {id: params[:id]}
    guides.update id, body
    id.to_json
  end
end