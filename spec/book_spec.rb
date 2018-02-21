require 'spec_helper'

describe Bibliotheca::Book do
  let(:haskell) { build(:haskell) }
  let(:bot) { double(Bibliotheca::Bot) }

  before { Bibliotheca::Collection::Languages.insert!(haskell) }

  before { Bibliotheca::Collection::Guides.insert!(first_guide) }
  before { Bibliotheca::Collection::Guides.insert!(second_guide) }
  before { Bibliotheca::Collection::Guides.insert!(third_guide) }

  before { Bibliotheca::Collection::Topics.insert!(first_topic) }
  before { Bibliotheca::Collection::Topics.insert!(second_topic) }

  let(:first_guide) {
    Bibliotheca::Guide.new name: 'first',
                           description: 'foobar',
                           slug: 'original/first-guide',
                           language: 'haskell',
                           exercises: [],
                           locale: 'en'
  }

  let(:second_guide) {
    Bibliotheca::Guide.new name: 'second',
                           description: 'foobar',
                           slug: 'original/second-guide',
                           language: 'haskell',
                           exercises: [],
                           locale: 'en'
  }

  let(:third_guide) {
    Bibliotheca::Guide.new name: 'third',
                           description: 'foobar',
                           slug: 'original/third-guide',
                           language: 'haskell',
                           exercises: [],
                           locale: 'en'
  }

  let(:first_topic) {
    Bibliotheca::Topic.new name: 'first',
                           slug: 'original/first-topic',
                           locale: 'en',
                           description: 'foobar',
                           lessons: ['original/first-guide', 'original/second-guide'] }

  let(:second_topic) {
    Bibliotheca::Topic.new name: 'second',
                           slug: 'original/second-topic',
                           locale: 'en',
                           description: 'foobar',
                           lessons: ['original/third-guide'] }

  describe 'fork_to!' do
    let(:book) { Bibliotheca::Book.new name: 'book',
                                       locale: 'en',
                                       description: 'foobar',
                                       slug: 'original/book',
                                       chapters: ['original/first-topic', 'original/second-topic'] }
    let(:book_id) { Bibliotheca::Collection::Books.find_by!(slug: 'original/book').id }
    let(:forked_book_id) { Bibliotheca::Collection::Books.find_by!(slug: 'another/book').id }

    before { Bibliotheca::Collection::Books.insert!(book) }

    before do
      expect(bot).to receive(:fork!).with('original/first-guide', 'another')
      expect(bot).to receive(:fork!).with('original/second-guide', 'another')
      expect(bot).to receive(:fork!).with('original/third-guide', 'another')
    end

    let!(:forked_book) { book.fork_to! 'another', bot }

    it { expect(book_id).to_not eq forked_book_id  }
    it { expect(forked_book_id).to_not be nil  }
    it { expect(forked_book.slug).to eq 'another/book' }

    it { expect(Bibliotheca::Collection::Guides.count).to eq 6 }
    it { expect(Bibliotheca::Collection::Topics.count).to eq 4 }
    it { expect(Bibliotheca::Collection::Books.count).to eq 2 }

    it { expect(Bibliotheca::Collection::Guides.find_by!(slug: 'another/first-guide')).to_not be nil }
    it { expect(Bibliotheca::Collection::Guides.find_by!(slug: 'another/second-guide')).to_not be nil }
    it { expect(Bibliotheca::Collection::Guides.find_by!(slug: 'another/third-guide')).to_not be nil }

    it { expect(Bibliotheca::Collection::Topics.find_by!(slug: 'another/first-topic')).to_not be nil }
    it { expect(Bibliotheca::Collection::Topics.find_by!(slug: 'another/second-topic')).to_not be nil }
  end

end
