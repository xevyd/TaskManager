FactoryBot.define do
  factory :task do
    name
    description
    state
    expired_at
    author factory: :user, :manager 
    assignee factory: :user, :developer
  end
end
