# frozen_string_literal: true

class Album < ApplicationRecord
  validates :title, presence: true
end
