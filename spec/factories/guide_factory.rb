FactoryBot.define do
  factory :guide do
    name { 'my guide' }
    slug { "flbulgarelli/mumuki-sample-guide-#{SecureRandom.uuid}" }
    exercises { [] }
    type { 'practice' }
    language
    description { 'foo' }
  end
end
