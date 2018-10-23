require_relative '../spec_helper'

describe 'routes' do
  before { create(:haskell, visible_success_output: false,
                            output_content_type: 'plain') }

  let(:request) {
    {
      language: 'haskell',
      solution: {
        test: %Q{describe "foo" $ do\n it "bar" $ do\n  foo = True},
        content: 'foo = True'
      }
    }
  }

  let(:exercise) {
    {id: 1, name: 'foo', type: 'problem', layout: 'input_right', editor: 'code', description: 'foo',
     test: %Q{describe "foo" $ do\n it "bar" $ do\n  foo = True}, solution: 'foo = True',
     manual_evaluation: false,
     choices: [],
     expectations: [{"binding" => 'foo', "inspection" => 'HasBinding'}],
     assistance_rules: [{"when" => 'content_empty', "then" => 'a message'}],
     randomizations: {},
     tag_list: [],
     extra_visible: false} }

  let(:guide) { import_from_api! :guide, name: 'foo', description: 'desc', language: 'haskell', slug: 'foo/bar', exercises: [exercise] }
  let!(:guide_id) { guide.id }

  before do
    import_from_api! :guide, name: 'foo2', description: 'desc', language: 'haskell', slug: 'baz/bar2', exercises: []
    import_from_api! :guide, name: 'foo3', description: 'desc', language: 'haskell', slug: 'baz/foo', exercises: []
    import_from_api! :guide, name: 'foo4', description: 'desc', language: 'haskell', slug: 'bar/foo4', exercises: [], private: true
  end

  def app
    Sinatra::Application
  end

  describe('get /guides/writable') do
    before do
      header 'Authorization', build_auth_header(writer: 'foo/*')
      get '/guides/writable'
    end

    it { expect(last_response).to be_ok }
    it { expect(last_response.body).to json_eq guides: [{name: 'foo', slug: 'foo/bar', language: 'haskell', type: 'practice'}] }
  end

  describe('get /guides') do
    context 'When user has permission to access private guides' do
      before do
        header 'Authorization', build_auth_header(writer: 'bar/*')
        get '/guides'
      end

      it { expect(last_response).to be_ok }
      it { expect(JSON.parse(last_response.body)['guides'].count).to eq 4 }
    end

    context 'When user has not permission to access private guides' do
      before { get '/guides' }

      it { expect(last_response).to be_ok }
      it { expect(JSON.parse(last_response.body)['guides'].count).to eq 3 }
    end
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
                                                    private: false,
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

  describe 'post /guides/fork' do
    context 'when request is valid' do
      it 'accepts valid requests' do
        expect_any_instance_of(Mumukit::Sync::Store::Github::GuideExport).to receive(:run!)
        expect_any_instance_of(Mumukit::Sync::Store::Github::Bot).to receive(:fork!)

        header 'Authorization', build_auth_header(writer: '*')

        post '/guides', {slug: 'bar/baz',
                         language: 'haskell',
                         name: 'Baz Guide',
                         description: 'foo',
                         exercises: [{name: 'Exercise 1', description: 'foo'}]}.to_json

        post '/guides/bar/baz/fork', { organization: 'foo' }.to_json

        expect(last_response).to be_ok
        expect(JSON.parse(last_response.body)['slug']).to eq 'foo/baz'
      end
    end
  end

  describe 'post /guides' do
    context 'when request is valid' do

      it 'accepts valid requests' do
        expect_any_instance_of(Mumukit::Sync::Store::Github::GuideExport).to receive(:run!)

        header 'Authorization', build_auth_header(writer: '*')

        post '/guides', {slug: 'bar/baz',
                         language: 'haskell',
                         name: 'Baz Guide',
                         description: 'foo',
                         exercises: [{name: 'Exercise 1', description: 'foo'}]}.to_json

        expect(last_response).to be_ok
        expect(JSON.parse(last_response.body)['id']).to_not be nil
      end

      it 'accepts valid requests with narrower permissions' do
        expect_any_instance_of(Mumukit::Sync::Store::Github::GuideExport).to receive(:run!)

        header 'Authorization', build_auth_header(editor: '*')

        post '/guides', {slug: 'bar/baz',
                         language: 'haskell',
                         name: 'Baz Guide',
                         description: 'foo',
                         exercises: [{name: 'Exercise 1', description: 'foo'}]}.to_json

        expect(last_response).to be_ok
        expect(JSON.parse(last_response.body)['id']).to_not be nil
      end

      it 'accepts re posts' do
        allow_any_instance_of(Mumukit::Sync::Store::Github::GuideExport).to receive(:run!)

        header 'Authorization', build_auth_header(writer: '*')

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
        expect_any_instance_of(Mumukit::Sync::Store::Github::Bot).to receive(:authenticated?).and_return(false)

        header 'Authorization', build_auth_header(writer: '*')

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
        header 'Authorization', build_auth_header(writer: '*')

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
        header 'Authorization', build_auth_header(writer: 'goo/foo')

        post '/guides', {slug: 'bar/baz', name: 'Baz Guide', exercises: [{name: 'Exercise 1'}]}.to_json

        expect(last_response).to_not be_ok
        expect(last_response.status).to eq 403
        expect(last_response.body).to json_eq message: 'Unauthorized access to bar/baz as writer. Scope is `goo/foo`'
      end

      it 'reject unauthorized requests' do
        header 'Authorization', build_auth_header(editor: 'goo/foo')

        post '/guides', {slug: 'bar/baz', name: 'Baz Guide', exercises: [{name: 'Exercise 1'}]}.to_json

        expect(last_response).to_not be_ok
        expect(last_response.status).to eq 403
        expect(last_response.body).to json_eq message: 'Unauthorized access to bar/baz as writer. Scope is ``'
      end

      it 'reject unauthenticated requests' do
        post '/guides', {slug: 'bar/baz',
                         name: 'Baz Guide',
                         exercises: [{name: 'Exercise 1'}]}.to_json

        expect(last_response).to_not be_ok
        expect(last_response.status).to eq 401
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
      allow_any_instance_of(Mumukit::Sync::Store::Github::GuideReader).to receive(:read_guide!).and_return(guide)
      allow(Git).to receive(:clone).and_return(Git::Base.new)
      allow_any_instance_of(Git::Base).to receive(:config)
    end

    context 'when bot is authenticated' do
      before do
        expect_any_instance_of(Mumukit::Sync::Store::Github::Bot).to receive(:register_post_commit_hook!)
      end
      it 'accepts valid requests' do
        post '/guides/import/pdep-utn/mumuki-funcional-guia-0'
        expect(last_response).to be_ok
      end
    end

    context 'when bot is not authenticated' do
      before do
        expect_any_instance_of(Mumukit::Sync::Store::Github::Bot).to receive(:authenticated?).and_return false
      end
      it 'accepts valid requests' do
        post '/guides/import/pdep-utn/mumuki-funcional-guia-0'
        expect(last_response).to be_ok
      end
    end
  end

  describe 'delete /guides/:id' do
    let(:guide) { create(:guide, slug: 'pdep-utn/mumuki-funcional-guia-0') }
    let(:id) { guide[:id] }

    context 'when user is authenticated and has permissions' do
      before { header 'Authorization', build_auth_header(editor: '*') }
      before { delete "/guides/#{id}" }

      it { expect(last_response).to be_ok }
      it { expect(Guide.exists? id: id).to be false }
    end

    context 'when user is authenticated but does not have enough permissions' do
      before { header 'Authorization', build_auth_header(writer: '*') }
      before { delete "/guides/#{id}" }

      it { expect(last_response).to_not be_ok }
      it { expect(last_response.status).to eq 403 }
      it { expect(Guide.exists? id: id).to be true }
    end

    context 'when user is not authenticated' do
      before { delete "/guides/#{id}" }

      it { expect(last_response).to_not be_ok }
      it { expect(Guide.exists? id: id).to be true }
    end

  end
end
