FactoryBot.define do
  sequence :name, aliases: [:first_name, :last_name, :description] do
    "Name #{n}"
  end

  sequence :password do
    [*('a'..'z'), *('0'..'9')].sample(8).join
  end

  sequence :email do |n|
    "testuser#{n}@test.test"
  end

  sequence :expired_at do
    (DateTime.current + 14).to_date
  end
end
