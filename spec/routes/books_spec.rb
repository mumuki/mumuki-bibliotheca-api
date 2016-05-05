require 'spec_helper'

require_relative '../../app/routes'

describe 'routes' do
  let!(:book_id) {
    Bibliotheca::Collection::Books.insert!(
        build(:book, name: 'the book', locale: 'es', slug: 'baz/foo', chapters: %w(bar/baz1 bar/baz2)))[:id] }

  after do
    Bibliotheca::Database.clean!
  end

  def app
    Sinatra::Application
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
end
