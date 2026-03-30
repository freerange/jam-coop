# frozen_string_literal: true

class Payout < ApplicationRecord
  STRIPE_TYPE = 'stripe'

  belongs_to :user
  has_many :purchases, dependent: :nullify

  validates :payout_type, presence: true
  validates :transaction_reference, presence: true
  validates :destination_reference, presence: true
  validates :amount_in_pence, presence: true
  validates :platform_fee_in_pence, presence: true

  def stripe?
    payout_type == STRIPE_TYPE
  end
end
