# frozen_string_literal: true

class PayoutDetail < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
end
