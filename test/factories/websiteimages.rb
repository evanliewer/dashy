FactoryBot.define do
  factory :websiteimage do
    association :team
    name { "MyString" }
    description { "MyString" }
    image { nil }
  end
end
