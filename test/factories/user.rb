# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'lazaronixon@example.com' }
    password_digest { BCrypt::Password.create('Secret1*3*5*') }
    verified { true }
  end
end
