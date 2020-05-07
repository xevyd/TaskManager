FactoryBot.define do
  factory :task do
    name
    description
    state
    expired_at
    
    trait :author_id do
      author_id
    end
    
    trait :assignee_id do
      assignee_id
    end
  end
end
