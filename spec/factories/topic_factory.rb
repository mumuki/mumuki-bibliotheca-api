FactoryBot.define do
  factory :topic, class: Bibliotheca::Topic do
    name { 'my topic' }
    slug { 'foo/bar' }
    lessons { [] }
    locale { 'en' }
    description { 'this topic is really interesting' }

    initialize_with do
      Bibliotheca::Topic.new(attributes)
    end
  end
end
