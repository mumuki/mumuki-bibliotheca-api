FactoryBot.define do
  factory :book do
    name { 'my book' }
    slug { "flbulgarelli/mumuki-sample-book-#{SecureRandom.uuid}" }
    chapters { [] }
    locale { 'en' }
    description { 'this book is for everyone and nobody' }
  end
end
