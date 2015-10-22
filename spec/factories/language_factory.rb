FactoryGirl.define do

  factory :language, class: GitIo::Language do
    sequence(:name) { |n| "lang#{n}" }
    sequence(:extension) { |n| "ext#{n}" }
  end

  factory :haskell, class: GitIo::Language do
    name
  end
end