FactoryBot.define do
  factory :license do
    key { SecureRandom.uuid }
    game
    user
  end
end
