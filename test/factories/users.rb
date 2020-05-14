FactoryBot.define do
  factory :user do
    first_name
    last_name
    password
    email

    factory :manager do
      type { 'Manager' }
    end

    factory :admin do
      type { 'Admin' }
    end

    factory :developer do
      type { 'Developer' }
    end
  end
end
