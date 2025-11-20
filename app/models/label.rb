# frozen_string_literal: true

class Label < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged
  belongs_to :user
  validates :name, presence: true
end
