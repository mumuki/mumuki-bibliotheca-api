require 'spec_helper'

describe 'routes' do
  before { create(:topic, slug: 'bar/baz1') }
  before { create(:topic, slug: 'bar/baz2') }
  before { create(:topic, slug: 'foo/bar') }

  before { create(:guide, slug: 'foo/complement') }

  let(:book) do
    import_from_api! :book,
                      name: 'the book',
                      description: 'this book is for everyone and nobody',
                      locale: 'es',
                      slug: 'baz/foo',
                      chapters: %w(bar/baz1 bar/baz2)
  end
  let!(:book_id) { book.id }

  def app
    Mumuki::Bibliotheca::App
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
                                         name: 'the book',
                                         description: 'this book is for everyone and nobody',
                                         locale: 'es',
                                         slug: 'baz/foo',
                                         chapters: %w(bar/baz1 bar/baz2),
                                         complements: []) }
  end

  describe('get /books/baz/foo/organizations') do
    before {
      book = Book.find_by_slug!('baz/foo')
      ['one', 'two', 'three', 'hidden'].each { |name|
        organization = create :organization, book: book, name: name
        create :usage, organization: organization, item: book
      }
      header 'Authorization', build_auth_header(student: 'one/*', teacher: 'two/*', writer: 'three/*')
      get '/books/baz/foo/organizations'
    }

    it { expect(last_response).to be_ok }
    it { expect(JSON.parse(last_response.body)).to match_array(
                                                    [
                                                      { 'name' => 'one' },
                                                      { 'name' => 'two' }
                                                    ]
                                                   )}
  end

  describe 'post /books' do
    let(:created_book) { Book.find_by(slug: 'borges/the-book-of-sand') }
    it 'accepts valid requests' do
      header 'Authorization', build_auth_header(writer: '*')
      post_json '/books', slug: 'borges/the-book-of-sand',
                          name: 'The Book of Sand',
                          locale: 'en',
                          description: 'foo',
                          invalid_field: 'zafaza',
                          complements: ['foo/complement'],
                          chapters: ['foo/bar']

      expect(last_response).to be_ok
      expect(created_book).to_not be nil
      expect(last_response.body).to json_like({slug: 'borges/the-book-of-sand',
                                              name: 'The Book of Sand',
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
