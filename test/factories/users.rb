FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "Firstname#{n}" }
    sequence(:last_name) { |n| "Lastname#{n}" }
    sequence(:password) { [*('a'..'z'), *('0'..'9')].sample(8).join }
    sequence(:email) { |n| "testuser#{n}@test.test" }
    sequence(:type) { ['admin', 'developer', 'manager'].sample }
  end
end
