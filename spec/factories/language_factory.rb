FactoryGirl.define do

  factory :language, class: Bibliotheca::Language do
    sequence(:name) { |n| "lang#{n}" }
    sequence(:extension) { |n| "ext#{n}" }
    sequence(:test_extension) { |n| "ext#{n}" }
  end

  factory :haskell, parent: :language do
    name 'haskell'
    extension 'hs'
    test_extension 'hs'
  end
end