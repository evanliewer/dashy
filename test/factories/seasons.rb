FactoryBot.define do
  factory :season do
    association :team
    name { "MyString" }
    item { nil }
    season_start { "2024-12-12 13:29:11" }
    season_end { "2024-12-12 13:29:11" }
    start_time { "2024-12-12 13:29:11" }
    end_time { "2024-12-12 13:29:11" }
    quantity { 1 }
    notes { "MyString" }
  end
end
