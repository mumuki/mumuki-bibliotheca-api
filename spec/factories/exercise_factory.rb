FactoryBot.define do
  factory :exercise do
    name { 'my exercise'}
    type { 'problem' }
    description { 'foo'}
    expectations { [] }
  end
end
