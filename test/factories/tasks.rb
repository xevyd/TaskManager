FactoryBot.define do
  factory :task do
    name
    description
    author
    assignee

    trait :author do
      author factory: :manager
    end

    trait :assignee do
      assignee factory: :developer
    end
  end
end
