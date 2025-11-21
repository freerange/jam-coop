# frozen_string_literal: true

class StripeConnectAccount < ApplicationRecord
  belongs_to :user

  validates :stripe_identifier, presence: true

  def status
    if charges_enabled?
      'charges_enabled'
    elsif details_submitted?
      'details_submitted'
    else
      'not_started'
    end
  end

  def accepts_payments?
    charges_enabled?
  end
end
