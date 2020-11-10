FactoryBot.define do
  factory :user do
    name { Faker::Name.email }
    email { Faker::Internet.email }
    password { '123456' }
    password_confirmation { '123456' }
    profile { %i(admin client).sample }
  end
end