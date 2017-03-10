FactoryGirl.define do
  factory :exercise, class: Bibliotheca::Exercise do
    name 'my exercise'
    type 'practice'
    description 'foo'

    initialize_with do
      Bibliotheca::Exercise.new(attributes)
    end
  end
end
