require 'spec_helper'

require_relative '../../app/routes'

describe 'routes' do
  let(:exercise) {
    {id: 1, name: 'foo', type: 'problem', layout: 'editor_right', description: 'foo',
     test: %Q{describe "foo" $ do\n it "bar" $ do\n  foo = True}, solution: 'foo = True',
     expectations: [{binding: 'foo', inspection: 'HasBinding'}], tag_list: [], extra_visible: false} }

  let!(:guide_id) {
    Bibliotheca::Collection::Guides.insert!(
        build(:guide, name: 'foo', language: 'haskell', slug: 'foo/bar', exercises: [exercise]))[:id] }

  before do
    Bibliotheca::Collection::Guides.insert!(
        build(:guide, name: 'foo2', language: 'haskell', slug: 'baz/bar2', exercises: []))
    Bibliotheca::Collection::Guides.insert!(
        build(:guide, name: 'foo3', language: 'haskell', slug: 'baz/foo', exercises: []))
  end

  after do
    Bibliotheca::Database.clean!
  end

  def app
    Sinatra::Application
  end

  describe('get /guides/writable') do
    before do
      header 'Authorization', build_auth_header('foo/*')
      get '/guides/writable'
    end

    it { expect(last_response).to be_ok }
    it { expect(last_response.body).to json_eq guides: [{name: 'foo', slug: 'foo/bar', id: guide_id, language: 'haskell', type: 'practice'}] }
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
                                                    type: 'practice',
                                                    id_format: '%05d',
                                                    name: 'foo',
                                                    language: 'haskell',
                                                    slug: 'foo/bar',
                                                    description: 'foo',
                                                    exercises: [exercise],
                                                    id: guide_id,
                                                    expectations: []}) }
      end
    end
    context 'When guide does not exist' do
      before { get '/guides/foo/bar2' }
      it { expect(last_response).to_not be_ok }
      it { expect(last_response.body).to json_eq(message: 'document {"slug":"foo/bar2"} not found') }
      it { expect(last_response.status).to be(404) }
    end
  end

  describe('get /guides/:guide_id/exercises/:exercise_id/test') do
    describe 'run tests for specific guide\'s exercise' do
      context 'When guide exists' do
        context 'and exercise exists too' do
          let(:response) { {status: 'passed'} }
          before { expect_any_instance_of(Mumukit::Bridge::Runner).to receive(:run_tests!).and_return(response) }
          before { get "/guides/#{guide_id}/exercises/1/test" }
          it { expect(last_response).to be_ok }
          it { expect(last_response.body).to json_eq(response) }
        end
        context 'and exercise does not exist' do
          before { get "/guides/#{guide_id}/exercises/2/test" }
          it { expect(last_response).to_not be_ok }
          it { expect(last_response.body).to json_eq(message: 'exercise 2 not found') }
          it { expect(last_response.status).to be(404) }
        end
      end
    end
    context 'When guide does not exist' do
      before { get '/guides/0123456789abcdef/exercises/1/test' }
      it { expect(last_response).to_not be_ok }
      it { expect(last_response.body).to json_eq(message: 'document {"id":"0123456789abcdef"} not found') }
      it { expect(last_response.status).to be(404) }
    end
  end

  describe 'post /guides' do
    context 'when request is valid' do

      it 'accepts valid requests' do
        expect_any_instance_of(Bibliotheca::IO::GuideExport).to receive(:run!)
        allow_any_instance_of(RestClient::Request).to receive(:execute)

        header 'Authorization', build_auth_header('*')

        post '/guides', {slug: 'bar/baz',
                         language: 'haskell',
                         name: 'Baz Guide',
                         description: 'foo',
                         exercises: [{name: 'Exercise 1', description: 'foo'}]}.to_json

        expect(last_response).to be_ok
        expect(JSON.parse(last_response.body)['id']).to_not be nil
      end

      it 'accepts re posts' do
        allow_any_instance_of(Bibliotheca::IO::GuideExport).to receive(:run!)
        allow_any_instance_of(RestClient::Request).to receive(:execute)

        header 'Authorization', build_auth_header('*')

        post '/guides', {slug: 'bar/baz',
                         name: 'Baz Guide',
                         language: 'haskell',
                         description: 'foo',
                         exercises: [{name: 'Exercise 1', description: 'foo'}]}.to_json
        id = JSON.parse(last_response.body)['id']

        post '/guides', {slug: 'bar/baz',
                         name: 'Bar Baz Guide',
                         language: 'haskell',
                         description: 'foo',
                         exercises: [{name: 'Exercise 1', description: 'foo'}]}.to_json

        expect(last_response).to be_ok
        expect(JSON.parse(last_response.body)['id']).to eq id
      end

      it 'does not export if bot is not authenticated' do
        expect_any_instance_of(Bibliotheca::Bot).to receive(:authenticated?).and_return(false)

        header 'Authorization', build_auth_header('*')

        post '/guides', {slug: 'bar/baz',
                         language: 'haskell',
                         name: 'Baz Guide',
                         description: 'foo',
                         exercises: [{name: 'Exercise 1', description: 'foo'}]}.to_json

        expect(last_response).to be_ok
        expect(JSON.parse(last_response.body)['id']).to_not be nil
      end
    end

    context 'when request is invalid' do
      it 'rejects invalid exercises' do
        header 'Authorization', build_auth_header('*')

        post '/guides', {slug: 'bar/baz',
                         language: 'haskell',
                         name: 'Baz Guide',
                         description: 'foo',
                         exercises: [{name: 'Exercise 1/fdf', description: 'foo'}]}.to_json

        expect(last_response).to_not be_ok
        expect(last_response.status).to be 400
        expect(last_response.body).to json_eq message: 'in exercise 1: Name must not contain a / character'
      end

      it 'reject unauthorized requests' do
        header 'Authorization', build_auth_header('goo/foo')

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
        expect(last_response.status).to eq 401
        expect(last_response.body).to json_eq message: 'missing authorization header'

      end

      it 'reject invalid tokens' do
        header 'Authorization', 'fooo'

        post '/guides', {slug: 'bar/baz',
                         name: 'Baz Guide',
                         exercises: [{name: 'Exercise 1'}]}.to_json

        expect(last_response).to_not be_ok
        expect(last_response.status).to eq 401
        expect(last_response.body).to json_eq message: 'Not enough or too many segments'
      end
    end
  end

  describe 'post /guides/import' do
    let(:guide) { build(:guide, slug: 'pdep-utn/mumuki-funcional-guia-0') }

    before do
      allow_any_instance_of(Bibliotheca::IO::GuideReader).to receive(:read_guide!).and_return(guide)
      allow(Git).to receive(:clone).and_return(Git::Base.new)
      allow_any_instance_of(Git::Base).to receive(:config)
    end

    context 'when bot is authenticated' do
      before do
        expect_any_instance_of(Bibliotheca::Bot).to receive(:register_post_commit_hook!)
      end
      it 'accepts valid requests' do
        post '/guides/import/pdep-utn/mumuki-funcional-guia-0'
        expect(last_response).to be_ok
      end
    end

    context 'when bot is not authenticated' do
      before do
        expect_any_instance_of(Bibliotheca::Bot).to receive(:authenticated?).and_return false
      end
      it 'accepts valid requests' do
        post '/guides/import/pdep-utn/mumuki-funcional-guia-0'
        expect(last_response).to be_ok
      end
    end
  end

  describe 'delete /guides/:id' do
    let(:guide) { build(:guide, slug: 'pdep-utn/mumuki-funcional-guia-0') }
    let(:id) { Bibliotheca::Collection::Guides.insert!(guide)[:id] }

    context 'when user is authenticated' do

      before do
        header 'Authorization', build_auth_header('*')

        delete "/guides/#{id}"
      end

      it { expect(last_response).to be_ok }
      it { expect(Bibliotheca::Collection::Guides.exists? id).to be false }
    end

    context 'when user is not authenticated' do
      before { delete "/guides/#{id}" }

      it { expect(last_response).to_not be_ok }
      it { expect(Bibliotheca::Collection::Guides.exists? id).to be true }
    end

  end
end
