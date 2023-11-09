# frozen_string_literal: true

class Interest < ApplicationRecord
  before_create :generate_confirm_token

  validates :email, uniqueness: true

  def email_activate
    self.email_confirmed = true
    save!
  end

  def suppress_sending?
    sending_suppressed_at.present?
  end

  private

  def generate_confirm_token
    return if confirm_token.present?

    self.confirm_token = SecureRandom.urlsafe_base64.to_s
  end
end
