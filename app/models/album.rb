# frozen_string_literal: true

class Album < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  validates :title, presence: true

  belongs_to :artist
end
