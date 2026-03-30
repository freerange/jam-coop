# frozen_string_literal: true

class Payout < ApplicationRecord
  belongs_to :user

  validates :payout_type, presence: true
  validates :transaction_reference, presence: true
  validates :destination_reference, presence: true
  validates :amount_in_pence, presence: true
  validates :platform_fee_in_pence, presence: true
end
