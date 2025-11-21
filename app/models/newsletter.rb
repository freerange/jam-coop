# frozen_string_literal: true

class Newsletter < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true

  def send_as_email
    users = User.where(verified: true, opt_in_to_newsletter: true, sending_suppressed_at: nil)
    users.find_each do |user|
      BroadcastMailer.with(recipient: user, newsletter: self).newsletter.deliver_later
    end

    interests = Interest.where(email_confirmed: true, sending_suppressed_at: nil)
    interests.find_each do |interest|
      BroadcastMailer.with(recipient: interest, newsletter: self).newsletter.deliver_later
    end
  end
end
