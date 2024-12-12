FactoryBot.define do
  factory :flights_check, class: 'Flights::Check' do
    association :team
    name { "MyString" }
    retreat { nil }
    flight { nil }
    user { nil }
    completed_at { "2024-12-11 22:06:33" }
  end
end
