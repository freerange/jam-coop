# frozen_string_literal: true

class Following < ApplicationRecord
  belongs_to :artist
  belongs_to :user
end
