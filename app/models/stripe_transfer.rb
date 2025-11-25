# frozen_string_literal: true

class StripeTransfer < ApplicationRecord
  belongs_to :stripe_account
  belongs_to :purchase

  validates :amount_in_pence, presence: true
end
