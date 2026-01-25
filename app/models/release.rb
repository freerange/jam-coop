# frozen_string_literal: true

class Release < ApplicationRecord
  belongs_to :album
  belongs_to :label

  validates :album_id, uniqueness: true
  validates :catalogue_number, length: { maximum: 12 }, allow_blank: true
end
