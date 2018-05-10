FactoryGirl.define do
  factory :exercise, class: Bibliotheca::Exercise do
    name 'my exercise'
    type 'problem'
    description 'foo'
    expectations []

    initialize_with do
      Bibliotheca::Exercise.new(attributes)
    end
  end
end
