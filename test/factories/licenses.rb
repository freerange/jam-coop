# frozen_string_literal: true

FactoryBot.define do
  factory :license do
    code { 'by' }
    label { 'Attribution' }
  end
end
