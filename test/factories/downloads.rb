# frozen_string_literal: true

FactoryBot.define do
  factory :download do
    format { 1 }
    album { nil }
  end
end
