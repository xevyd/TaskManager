FactoryBot.define do
  factory :task do
    name
    description
    expired_at
    author factory: :manager
    assignee factory: :developer
  end
end
