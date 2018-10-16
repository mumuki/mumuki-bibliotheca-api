FactoryBot.define do
  factory :book, class: Bibliotheca::Book do
    name { 'my book' }
    slug { 'foo/bar' }
    chapters { [] }
    locale { 'en' }
    description { 'this book is for everyone and nobody' }

    initialize_with do
      Bibliotheca::Book.new(attributes)
    end
  end
end
