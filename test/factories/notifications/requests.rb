FactoryBot.define do
  factory :notifications_request, class: 'Notifications::Request' do
    association :team
    name { "MyString" }
    user { nil }
    notifications_flag { nil }
    days_before { 1 }
    email { false }
  end
end
