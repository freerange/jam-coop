# frozen_string_literal: true

class Newsletter < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true
end
