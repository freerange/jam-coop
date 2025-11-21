# frozen_string_literal: true

class BroadcastMailer < ApplicationMailer
  def newsletter(recipient)
    return if recipient.suppress_sending?

    mail(
      to: recipient.email,
      subject: 'jam.coop - Newsletter #3',
      track_opens: 'true',
      message_stream: 'broadcast'
    )
  end
end
