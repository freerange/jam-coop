# frozen_string_literal: true

class ProfileLink < ApplicationRecord
  belongs_to :artist
  acts_as_list scope: :artist

  validates :url, presence: true
end
