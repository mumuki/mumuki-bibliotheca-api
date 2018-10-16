FactoryBot.define do
  factory :guide, class: Bibliotheca::Guide do
    name { 'my guide' }
    slug { 'foo/bar' }
    exercises { [] }
    type { 'practice' }
    language { 'haskell' }
    description { 'foo' }

    initialize_with do
      Bibliotheca::Guide.new(attributes)
    end
  end
end
