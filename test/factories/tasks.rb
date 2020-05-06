FactoryBot.define do
  factory :task do
    sequence(:name) { "Task#{n}" }
    sequence(:description) { "Task #{n} description" }
    author_id
    assignee_id
    state { 'State' }
    expired_at { '2020-04-30' }
  end
end
