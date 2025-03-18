# frozen_string_literal: true

class StripeConnectAccount < ApplicationRecord
  belongs_to :user

  validates :stripe_identifier, presence: true
end
