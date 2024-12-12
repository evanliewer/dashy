FactoryBot.define do
  factory :notification do
    association :team
    name { "MyString" }
    user { nil }
    read_at { "2024-12-11 22:33:25" }
    emailed { false }
  end
end
