# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password_digest { '$2a$12$J5ftEJ8yxoPj6oLuenHNQOPPghdQWwVeB4Puj5o7d8W6uaTdCQyGS' }
    verified { true }
  end
end
