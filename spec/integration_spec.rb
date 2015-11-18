require 'spec_helper'

require_relative '../app/routes'

describe 'routes' do
  let!(:guide_id) {
    GuideCollection.insert({name: 'foo', language: 'haskell', github_repository: 'foo/bar', exercises: []})[:id]
  }

  after do
    Database.client[:guides].drop
  end

  def app
    Sinatra::Application
  end

  it "shows guide by id" do
    get "/guides/#{guide_id}"

    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World')
  end

  it "shows guide by slug" do
    get '/guides/foo/bar'

    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World')
  end

  it "guide creation" do
    post '/guides', {github_repository: 'bar/baz'}, {'CONTENT_TYPE' => 'application/json'}

    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World')
  end
end