require 'spec_helper'

describe Book do
  let(:syncer) { double(:syncer) }
  let!(:haskell) { create(:haskell) }
  let!(:first_guide) {
    import_from_api! :guide,
                    name: 'first',
                    description: 'foobar',
                    slug: 'original/first-guide',
                    language: 'haskell',
                    exercises: [],
                    locale: 'en'
  }

  let!(:second_guide) {
    import_from_api! :guide,
                    name: 'second',
                    description: 'foobar',
                    slug: 'original/second-guide',
                    language: 'haskell',
                    exercises: [],
                    locale: 'en'
  }

  let!(:third_guide) {
    import_from_api! :guide,
                    name: 'third',
                    description: 'foobar',
                    slug: 'original/third-guide',
                    language: 'haskell',
                    exercises: [],
                    locale: 'en'
  }

  let!(:first_topic) {
    import_from_api! :topic,
                      name: 'first',
                      slug: 'original/first-topic',
                      locale: 'en',
                      description: 'foobar',
                      lessons: ['original/first-guide', 'original/second-guide'] }

  let!(:second_topic) {
    import_from_api! :topic,
                      name: 'second',
                      slug: 'original/second-topic',
                      locale: 'en',
                      description: 'foobar',
                      lessons: ['original/third-guide'] }

  describe 'fork_to!' do
    let!(:book) { import_from_api! :book,
                                  name: 'book',
                                  locale: 'en',
                                  description: 'foobar',
                                  slug: 'original/book',
                                  chapters: ['original/first-topic', 'original/second-topic'] }
    let(:book_id) { Book.find_by!(slug: 'original/book').id }
    let(:forked_book_id) { Book.find_by!(slug: 'another/book').id }

    before do
      expect(syncer).to receive(:export!).with(instance_of(Book))
      expect(syncer).to receive(:export!).with(instance_of(Book))
      expect(syncer).to receive(:export!).with(instance_of(Book))
    end

    let!(:forked_book) { book.fork_to! 'another', syncer }

    it { expect(book_id).to_not eq forked_book_id  }
    it { expect(forked_book_id).to_not be nil  }
    it { expect(forked_book.slug).to eq 'another/book' }

    it { expect(Guide.count).to eq 6 }
    it { expect(Topic.count).to eq 4 }
    it { expect(Book.count).to eq 2 }

    it { expect(Guide.find_by!(slug: 'another/first-guide')).to_not be nil }
    it { expect(Guide.find_by!(slug: 'another/second-guide')).to_not be nil }
    it { expect(Guide.find_by!(slug: 'another/third-guide')).to_not be nil }

    it { expect(Topic.find_by!(slug: 'another/first-topic')).to_not be nil }
    it { expect(Topic.find_by!(slug: 'another/second-topic')).to_not be nil }
  end

end
