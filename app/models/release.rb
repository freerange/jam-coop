# frozen_string_literal: true

class Release < ApplicationRecord
  belongs_to :album
  belongs_to :label
end
