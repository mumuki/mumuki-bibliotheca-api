require 'spec_helper'

require_relative '../app/routes'

describe 'routes' do
  let!(:guide_id) {
    Bibliotheca::Collection::Guides.insert({name: 'foo', language: 'haskell', slug: 'foo/bar', exercises: []})[:id]
  }
  before do
    Bibliotheca::Collection::Guides.insert({name: 'foo2', language: 'haskell', slug: 'baz/bar2', exercises: []})[:id]
    Bibliotheca::Collection::Guides.insert({name: 'foo3', language: 'haskell', slug: 'baz/foo', exercises: []})[:id]
  end

  after do
    Bibliotheca::Collection::Database.client[:guides].drop
  end

  def app
    Sinatra::Application
  end

  describe('get /languages') do
    before do
      get '/languages'
    end

    it { expect(last_response).to be_ok }
    pending { expect(last_response.body).to json_eq({languages: [
        {name: 'haskell', extension: 'hs'},
        {name: 'java', extension: 'java'},
        {name: 'wollok', extension: 'wlk'},
        {name: 'c', extension: 'c'},
        {name: 'prolog', extension: 'pl'},
        {name: 'ruby', extension: 'rb'},
        {name: 'gobstones', extension: 'gbs'},
        {name: 'javascript', extension: 'js'}]}) }
  end


  describe('get /guides/writable') do
    before do
      header 'X-Mumuki-Auth-Token', Mumukit::Auth::Token.build('foo/*').encode
      get '/guides/writable'
    end

    it { expect(last_response).to be_ok }
    it { expect(last_response.body).to json_eq guides: [{name: 'foo', slug: 'foo/bar', id: guide_id, language: 'haskell'}] }
  end

  describe('get /guides') do
    before do
      get '/guides'
    end

    it { expect(last_response).to be_ok }
    it { expect(JSON.parse(last_response.body)['guides'].count).to eq 3 }
  end

  describe('get /guides/:slug') do
    describe 'shows guide by slug' do
      context 'When guide exists' do
        before { get '/guides/foo/bar' }
        it { expect(last_response).to be_ok }
        it { expect(last_response.body).to json_eq({beta: false,
                                                    learning: false,
                                                    original_id_format: '%05d',
                                                    name: 'foo', language: 'haskell',
                                                    slug: 'foo/bar',
                                                    exercises: [],
                                                    id: guide_id}) }
      end
    end
    context 'When guide does not exist' do
      before { get '/guides/foo/bar2' }
      it { expect(last_response).to_not be_ok }
      it { expect(last_response.body).to json_eq(message: 'guide {"slug":"foo/bar2"} not found') }
      it { expect(last_response.status).to be(404) }
    end
  end

  describe 'post /guides' do
    context 'when request is valid' do

      it 'accepts valid requests' do
        expect_any_instance_of(Bibliotheca::IO::Export).to receive(:run!)

        header 'X-Mumuki-Auth-Token', Mumukit::Auth::Token.build('*').encode

        post '/guides', {slug: 'bar/baz',
                         language: 'haskell',
                         name: 'Baz Guide',
                         exercises: [{name: 'Exercise 1'}]}.to_json

        expect(last_response).to be_ok
        expect(JSON.parse(last_response.body)['id']).to_not be nil
      end

      it 'accepts re posts' do
        allow_any_instance_of(Bibliotheca::IO::Export).to receive(:run!)

        header 'X-Mumuki-Auth-Token', Mumukit::Auth::Token.build('*').encode

        post '/guides', {slug: 'bar/baz',
                         name: 'Baz Guide',
                         language: 'haskell',
                         exercises: [{name: 'Exercise 1'}]}.to_json
        id = JSON.parse(last_response.body)['id']

        post '/guides', {slug: 'bar/baz',
                         name: 'Bar Baz Guide',
                         language: 'haskell',
                         exercises: [{name: 'Exercise 1'}]}.to_json

        expect(last_response).to be_ok
        expect(JSON.parse(last_response.body)['id']).to eq id
      end
    end

    context 'when request is invalid' do
      it 'reject unauthorized requests' do
        header 'X-Mumuki-Auth-Token', Mumukit::Auth::Token.build('goo/foo').encode

        post '/guides', {slug: 'bar/baz', name: 'Baz Guide', exercises: [{name: 'Exercise 1'}]}.to_json

        expect(last_response).to_not be_ok
        expect(last_response.status).to eq 403
        expect(last_response.body).to json_eq message: 'Unauthorized access to bar/baz. Permissions are goo/foo'

      end

      it 'reject unauthenticated requests' do
        post '/guides', {slug: 'bar/baz',
                         name: 'Baz Guide',
                         exercises: [{name: 'Exercise 1'}]}.to_json

        expect(last_response).to_not be_ok
        expect(last_response.status).to eq 412
        expect(last_response.body).to json_eq message: 'Nil JSON web token'

      end

      it 'reject invalid tokens' do
        header 'X-Mumuki-Auth-Token', 'fooo'

        post '/guides', {slug: 'bar/baz',
                         name: 'Baz Guide',
                         exercises: [{name: 'Exercise 1'}]}.to_json

        expect(last_response).to_not be_ok
        expect(last_response.status).to eq 412
        expect(last_response.body).to json_eq message: 'Not enough or too many segments'
      end
    end
  end

  describe 'post /guides/import' do
    it 'accepts valid requests' do
      header 'X-Mumuki-Auth-Token', Mumukit::Auth::Token.build('*').encode
      post '/guides/import/pdep-utn/mumuki-funcional-guia-0'
      expect(last_response).to be_ok
    end
  end
end
