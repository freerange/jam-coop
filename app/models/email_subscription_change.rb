# frozen_string_literal: true

class EmailSubscriptionChange < ApplicationRecord
  belongs_to :user

  validates :message_id, :origin, :changed_at, presence: true
  validates :suppression_reason, presence: true, if: ->(c) { c.suppress_sending? }
end
