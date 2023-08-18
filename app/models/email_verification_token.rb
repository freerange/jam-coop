# frozen_string_literal: true

class EmailVerificationToken < ApplicationRecord
  belongs_to :user
end
