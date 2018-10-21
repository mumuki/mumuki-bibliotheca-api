FactoryBot.define do
  factory :topic do
    name { 'my topic' }
    slug { "flbulgarelli/mumuki-sample-topic-#{SecureRandom.uuid}" }
    lessons { [] }
    locale { 'en' }
    description { 'this topic is really interesting' }
  end
end
