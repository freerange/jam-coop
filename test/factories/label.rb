# frozen_string_literal: true

FactoryBot.define do
  factory :label do
    user
    name { 'Jam Records' }
  end
end
