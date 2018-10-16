require 'spec_helper'

describe 'routes' do
  let!(:book_id) {
    Bibliotheca::Collection::Books.insert!(
      build(:book, name: 'the book', locale: 'es', slug: 'baz/foo', chapters: %w(bar/baz1 bar/baz2)))[:id] }

  def app
    Sinatra::Application
  end

  describe('get /books/writable') do
    context 'when no topics match' do
      before do
        header 'Authorization', build_auth_header(writer: 'foo/*')
        get '/books/writable'
      end

      it { expect(last_response).to be_ok }
      it { expect(last_response.status).to eq 200 }
      it { expect(JSON.parse(last_response.body)['books'].count).to eq 0 }
    end

    context 'when topics match' do
      before do
        header 'Authorization', build_auth_header(writer: 'baz/*')
        get '/books/writable'
      end

      it { expect(last_response).to be_ok }
      it { expect(JSON.parse(last_response.body)['books'].count).to eq 1 }
    end
  end


  describe('get /books') do
    before do
      get '/books'
    end

    it { expect(last_response).to be_ok }
    it { expect(JSON.parse(last_response.body)['books'].count).to eq 1 }
  end

  describe('get /books/baz/foo') do
    before { get '/books/baz/foo' }

    it { expect(last_response).to be_ok }
    it { expect(last_response.body).to json_eq(
                                         id: book_id,
                                         name: 'the book',
                                         description: 'this book is for everyone and nobody',
                                         locale: 'es',
                                         slug: 'baz/foo',
                                         chapters: %w(bar/baz1 bar/baz2)) }
  end

  describe 'post /books' do
    let(:created_book) { Bibliotheca::Collection::Books.find_by!(slug: 'bar/a-book') }
    it 'accepts valid requests' do
      header 'Authorization', build_auth_header(writer: '*')
      post '/books', {slug: 'bar/a-book',
                      name: 'Baz Topic',
                      locale: 'en',
                      description: 'foo',
                      invalid_field: 'zafaza',
                      complements: ['foo/complement'],
                      chapters: ['foo/bar']}.to_json

      expect(last_response).to be_ok
      expect(created_book).to json_like({slug: 'bar/a-book',
                                         name: 'Baz Topic',
                                         locale: 'en',
                                         description: 'foo',
                                         complements: ['foo/complement'],
                                         chapters: ['foo/bar']}, except: :id)
    end
  end

  describe 'delete /books/baz/foo' do
    describe 'when the user has permissions' do
      before {
        header 'Authorization', build_auth_header(editor: 'baz/*')
        delete '/books/baz/foo'
      }

      it { expect(last_response).to be_ok }
      it { expect(last_response.body).to json_eq({}) }

      it 'indeed deletes the entity' do
        get '/books/baz/foo'

        expect(last_response.status).to be(404)
      end
    end

    describe 'when the user doesnt have permissions' do
      before {
        header 'Authorization', build_auth_header(writer: 'baz/*')
        delete '/books/baz/foo'
      }

      it { expect(last_response.status).to be(403) }
    end
  end
end
