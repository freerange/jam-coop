# frozen_string_literal: true

class Track < ApplicationRecord
  belongs_to :album
  delegate :artist, to: :album
end
