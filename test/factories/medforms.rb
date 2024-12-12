FactoryBot.define do
  factory :medform do
    association :team
    name { "MyString" }
    retreat { nil }
    phone { "MyString" }
    email { "MyString" }
    gender { "MyString" }
    emergency_contact_name { "MyString" }
    emergency_contact_phone { "MyString" }
    emergency_contact_relationship { "MyString" }
    terms { false }
    form_for { "MyString" }
    age { "MyString" }
    diet { nil }
  end
end
