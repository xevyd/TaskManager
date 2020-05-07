FactoryBot.define do
  factory :task do
    name
    description
    author_id
    assignee_id
    state
    expired_at
  end
end
