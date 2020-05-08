FactoryBot.define do
  factory :task do
    name
    description
    state { 'new_task' }
    expired_at
    author_id
    assignee_id
  end
end
