# frozen_string_literal: true

FactoryBot.define do
  factory :album do
    artist
    title { 'Whenever You Need Somebody' }
  end
end
