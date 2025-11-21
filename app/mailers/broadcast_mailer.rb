# frozen_string_literal: true

class BroadcastMailer < ApplicationMailer
  def newsletter(recipient, newsletter)
    return if recipient.suppress_sending?

    @newsletter = newsletter

    mail(
      to: recipient.email,
      subject: "jam.coop - #{@newsletter.title}",
      track_opens: 'true',
      message_stream: 'broadcast'
    )
  end
end
