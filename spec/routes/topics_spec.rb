require 'spec_helper'

describe 'routes' do
  let!(:guide_1) { create(:guide, slug: 'bar/baz1') }
  let!(:guide_2) { create(:guide, slug: 'bar/baz2') }

  let(:topic) do
    import_from_api! :topic,
                     name: 'the topic',
                     description: 'this is important!',
                     locale: 'es',
                     slug: 'baz/foo',
                     lessons: %w(bar/baz1 bar/baz2)
  end
  let!(:topic_id) { topic.id }


  def app
    Mumuki::Bibliotheca::App
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
                                         name: 'the topic',
                                         description: 'this is important!',
                                         locale: 'es',
                                         slug: 'baz/foo',
                                         lessons: %w(bar/baz1 bar/baz2)) }
  end

  describe('get /topics/baz/foo/organizations') do
    before {
      ['one', 'two', 'three', 'hidden'].each { |name|
        topic = Topic.find_by_slug! 'baz/foo'
        organization = create :organization, book: create(:book), name: name
        create :usage, organization: organization, item: topic
      }
      header 'Authorization', build_auth_header(student: 'one/*', teacher: 'two/*', writer: 'three/*')
      get '/topics/baz/foo/organizations'
    }

    it { expect(last_response).to be_ok }
    it { expect(JSON.parse(last_response.body)).to match_array(
                                                     [
                                                       { 'name' => 'one' },
                                                       { 'name' => 'two' }
                                                     ]
                                                   )}
  end

  describe 'post /topics' do
    let(:created_topic) { Topic.find_by!(slug: 'bar/a-topic') }
    before { create(:guide, slug: 'foo/bar' )}
    before do
      header 'Authorization', build_auth_header(writer: '*')
      post_json '/topics', slug: 'bar/a-topic',
                           name: 'Baz Topic',
                           locale: 'en',
                           description: 'foo',
                           invalid_field: 'zafaza',
                           lessons: ['foo/bar']
    end
    it { expect(last_response).to be_ok }
    it { expect(last_response.body).to json_like created_topic.to_resource_h }
    it do
      expect(created_topic.to_resource_h).to json_like({slug: 'bar/a-topic',
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
