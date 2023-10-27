# frozen_string_literal: true

FactoryBot.define do
  factory :purchase do
    album factory: :album, price: 3.00
    price { 5.00 }
  end
end
