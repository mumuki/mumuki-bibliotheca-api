FactoryBot.define do
  factory :exercise do
    name { 'my exercise'}
    bibliotheca_id { 1 }
    number { 1 }
    language
    test { 'dont care' }
    type { 'problem' }
    description { 'foo'}
    expectations { [] }
  end
end
