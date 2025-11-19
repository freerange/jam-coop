# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :artists, dependent: :restrict_with_exception
  has_many :email_verification_tokens, dependent: :destroy
  has_many :password_reset_tokens, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :followings, dependent: :destroy
  has_many :followed_artists, through: :followings, source: :artist
  has_one :payout_detail, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: 12 }

  before_validation if: -> { email.present? } do
    self.email = email.downcase.strip
  end

  before_update if: :email_changed? do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  after_update if: :verified_previously_changed? do
    Purchase.where(customer_email: email).update(user: self) if verified
  end

  def suppress_sending?
    sending_suppressed_at.present?
  end

  def signed_in?
    true
  end

  def collection
    purchases.where(completed: true)
  end

  def owns?(album)
    collection.exists?(album:)
  end
end
