FactoryBot.define do
  factory :retreat do
    association :team
    name { "MyString" }
    description { "MyString" }
    arrival { "2024-12-11 19:37:55" }
    departure { "2024-12-11 19:37:55" }
    contract_count { 1 }
    organization { nil }
    internal { false }
    active { false }
    actual_count { 1 }
    nps { 1 }
    debrief { "MyString" }
    dining_style { "MyString" }
  end
end
