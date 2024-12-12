FactoryBot.define do
  factory :reservation do
    association :team
    name { "MyString" }
    retreat { nil }
    item { nil }
    user { nil }
    start_time { "2024-12-11 19:50:11" }
    end_time { "2024-12-11 19:50:11" }
    quantity { 1 }
    notes { "MyString" }
    seasonal_default { false }
    exclusive { false }
    active { false }
    dining_style { "MyString" }
  end
end
