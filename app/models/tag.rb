# frozen_string_literal: true

class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :musicbrainz_id, uniqueness: { allow_blank: true }
end
