# frozen_string_literal: true

class Interest < ApplicationRecord
  validates :email, uniqueness: true
end
