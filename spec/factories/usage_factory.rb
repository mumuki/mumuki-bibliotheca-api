FactoryBot.define do
  factory :usage do
    parent_item { create(:book) }
  end
end
