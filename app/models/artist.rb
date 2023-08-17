# frozen_string_literal: true

class Artist < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :albums, dependent: :destroy
end
