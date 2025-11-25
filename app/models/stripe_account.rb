# frozen_string_literal: true

class StripeAccount < ApplicationRecord
  belongs_to :user

  validates :stripe_identifier, presence: true
end
