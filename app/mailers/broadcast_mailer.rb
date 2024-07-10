# frozen_string_literal: true

class BroadcastMailer < ApplicationMailer
  def newsletter(user)
    return if user.suppress_sending?

    mail(
      to: user.email,
      subject: 'jam.coop - Newsletter #2',
      track_opens: 'true',
      message_stream: 'broadcast'
    )
  end
end
