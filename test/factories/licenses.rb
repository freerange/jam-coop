FactoryBot.define do
  factory :license do
    text { Faker::String.random }
    code { Faker::String.random(length: [0, 2]) }
  end
end
