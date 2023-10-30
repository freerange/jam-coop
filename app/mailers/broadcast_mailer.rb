# frozen_string_literal: true

class BroadcastMailer < ApplicationMailer
  def test(user)
    return if user.suppress_sending?

    mail(
      to: user.email,
      subject: 'Testing BroadcastMailer',
      track_opens: 'true',
      message_stream: 'broadcast'
    )
  end
end
