FactoryGirl.define do
  factory :guide do
    name 'my guide'
    slug 'foo/bar'
    exercises []
    type 'practice'
    language 'haskell'

    initialize_with do
      Bibliotheca::Guide.new(attributes)
    end
  end
end