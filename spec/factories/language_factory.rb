FactoryBot.define do
  factory :language do
    sequence(:name) { |n| "lang#{n}" }
    sequence(:extension) { |n| "ext#{n}" }
    sequence(:test_extension) { |n| "ext#{n}" }
    runner_url { Faker::Internet.url }
  end

  factory :gobstones, parent: :language do
    name { 'gobstones' }
    extension { 'gbs' }
    test_extension { 'yaml' }
    queriable { false }
  end


  factory :haskell, parent: :language do
    name { 'haskell' }
    extension { 'hs' }
    test_extension { 'hs' }
    queriable { true }
  end

  factory :text, parent: :language do
    name { 'text' }
    extension { 'yml' }
    test_extension { 'yml' }
  end
end
