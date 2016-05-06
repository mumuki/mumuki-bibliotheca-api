require 'spec_helper'

require_relative '../../app/routes'

describe 'routes' do

  let!(:topic_id) {
    Bibliotheca::Collection::Topics.insert!(
        build(:topic,
              name: 'the topic',
              description: 'this is important!',
              locale: 'es',
              slug: 'baz/foo',
              lessons: %w(bar/baz1 bar/baz2)))[:id] }
  after do
    Bibliotheca::Database.clean!
  end

  def app
    Sinatra::Application
  end

  describe('get /topics') do
    before do
      get '/topics'
    end

    it { expect(last_response).to be_ok }
    it { expect(JSON.parse(last_response.body)['topics'].count).to eq 1 }
  end

  describe('get /topics/baz/foo') do
    before { get '/topics/baz/foo' }

    it { expect(last_response).to be_ok }
    it { expect(last_response.body).to json_eq(
                                           id: topic_id,
                                           name: 'the topic',
                                           description: 'this is important!',
                                           locale: 'es',
                                           slug: 'baz/foo',
                                           lessons: %w(bar/baz1 bar/baz2)) }
  end
end
