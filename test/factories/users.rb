FactoryBot.define do
  factory :user do
    first_name
    last_name
    password
    email

    factory :manager do
      type { 'manager' }
    end
  end
end
