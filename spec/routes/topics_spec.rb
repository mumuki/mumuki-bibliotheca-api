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

  def app
    Sinatra::Application
  end

  describe('get /topics/writable') do
    context 'when no topics match' do
      before do
        header 'Authorization', build_auth_header(writer: 'foo/*')
        get '/topics/writable'
      end

      it { expect(last_response).to be_ok }
      it { expect(JSON.parse(last_response.body)['topics'].count).to eq 0 }
    end

    context 'when topics match' do
      before do
        header 'Authorization', build_auth_header(writer: 'baz/*')
        get '/topics/writable'
      end

      it { expect(last_response).to be_ok }
      it { expect(JSON.parse(last_response.body)['topics'].count).to eq 1 }
    end
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


  describe 'post /topics' do
    let(:created_topic) { Bibliotheca::Collection::Topics.find_by!(slug: 'bar/a-topic') }
    it 'accepts valid requests' do
      header 'Authorization', build_auth_header(writer: '*')
      post '/topics', {slug: 'bar/a-topic',
                       name: 'Baz Topic',
                       locale: 'en',
                       description: 'foo',
                       invalid_field: 'zafaza',
                       lessons: ['foo/bar']}.to_json

      expect(last_response).to be_ok
      expect(created_topic).to json_like({slug: 'bar/a-topic',
                                          name: 'Baz Topic',
                                          locale: 'en',
                                          description: 'foo',
                                          lessons: ['foo/bar']}, except: :id)
    end
  end

  describe 'delete /topics/baz/foo' do
    describe 'when the user has permissions' do
      before {
        header 'Authorization', build_auth_header(editor: 'baz/*')
        delete '/topics/baz/foo'
      }

      it { expect(last_response).to be_ok }
      it { expect(last_response.body).to json_eq({}) }

      it 'indeed deletes the entity' do
        get '/topics/baz/foo'

        expect(last_response.status).to be(404)
      end
    end

    describe 'when the user doesnt have permissions' do
      before {
        header 'Authorization', build_auth_header(writer: 'baz/*')
        delete '/topics/baz/foo'
      }

      it { expect(last_response.status).to be(403) }
    end
  end
end
