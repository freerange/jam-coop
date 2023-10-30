# frozen_string_literal: true

class EmailSubscriptionChange < ApplicationRecord
  belongs_to :user

  validates :message_id, :origin, :suppression_reason, :changed_at, presence: true
end
