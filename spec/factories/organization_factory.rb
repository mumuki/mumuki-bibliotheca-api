FactoryBot.define do
  factory :organization do
    name { 'organization' }
    contact_email { 'a@a.com' }
    locale { 'en' }
    time_zone { 'UTC' }
  end
end
