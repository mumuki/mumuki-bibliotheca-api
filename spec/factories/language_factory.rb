FactoryGirl.define do
  factory :language, class: Bibliotheca::Language do
    sequence(:name) { |n| "lang#{n}" }
    sequence(:extension) { |n| "ext#{n}" }
    sequence(:test_extension) { |n| "ext#{n}" }

    initialize_with { new(attributes) }
  end

  factory :haskell, parent: :language do
    name 'haskell'
    extension 'hs'
    test_extension 'hs'
  end

  factory :text, parent: :language do
    name 'text'
    extension 'yml'
    test_extension 'yml'
  end
end
