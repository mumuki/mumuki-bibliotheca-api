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
    expect(last_response).to be_ok
    expect(last_response.body).to json_eq({beta: false,
                                           learning: false,
                                           original_id_format: "%05d",
                                           name: "foo", language: "haskell",
                                           github_repository: "foo/bar",
                                           exercises: [],
                                           id: guide_id})
  end

  describe('get /guides/:slug') do
    it "shows guide by slug" do
      get '/guides/foo/bar'

      expect(last_response).to be_ok
      expect(last_response.body).to json_eq({beta: false,
                                             learning: false,
                                             original_id_format: "%05d",
                                             name: "foo", language: "haskell",
                                             github_repository: "foo/bar",
                                             exercises: [],
                                             id: guide_id})
    end
  end

  describe 'guide creation' do
    it 'accepts valid requests' do
      header 'X-Mumuki-Auth-Token', Mumukit::Auth::Token.build('*').encode

      post '/guides', {github_repository: 'bar/baz', name: 'Baz Guide', exercises: [{name: 'Exercise 1'}]}.to_json

      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)['id']).to_not be nil
    end

    it 'reject unauthorized requests' do
      header 'X-Mumuki-Auth-Token', Mumukit::Auth::Token.build('goo/foo').encode

      post '/guides', {github_repository: 'bar/baz', name: 'Baz Guide', exercises: [{name: 'Exercise 1'}]}.to_json

      expect(last_response).to_not be_ok
      expect(last_response.status).to eq 403
      expect(last_response.body).to json_eq message: 'unauthorized'

    end

    it 'reject unauthenticated requests' do
      post '/guides', {github_repository: 'bar/baz', name: 'Baz Guide', exercises: [{name: 'Exercise 1'}]}.to_json

      expect(last_response).to_not be_ok
      expect(last_response.status).to eq 412
      expect(last_response.body).to json_eq message: 'Nil JSON web token'

    end

    it 'reject invalid tokens' do
      header 'X-Mumuki-Auth-Token', 'fooo'

      post '/guides', {github_repository: 'bar/baz', name: 'Baz Guide', exercises: [{name: 'Exercise 1'}]}.to_json

      expect(last_response).to_not be_ok
      expect(last_response.status).to eq 412
      expect(last_response.body).to json_eq message: 'Not enough or too many segments'
    end


  end
end