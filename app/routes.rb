require 'sinatra'
require 'mongo'
require 'securerandom'
require 'json'
require 'json/ext'

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
end

get '/guides/:id' do
  guide = guides.find id: params['id']
  guide.to_a.first.to_json
end

post '/guides' do
  id = {id: new_id}
  guides.insert_one JSON.parse(request.body.read).merge(id)
  id.to_json
end