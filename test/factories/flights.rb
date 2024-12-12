FactoryBot.define do
  factory :flight do
    association :team
    name { "MyString" }
  end
end
