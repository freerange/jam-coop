# frozen_string_literal: true

class License < ApplicationRecord
  validates :code, presence: true
  validates :label, presence: true
end
