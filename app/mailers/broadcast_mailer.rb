# frozen_string_literal: true

class BroadcastMailer < ApplicationMailer
  def newsletter
    recipient = params[:recipient]
    @newsletter = params[:newsletter]

    return if recipient.suppress_sending?

    mail(
      to: recipient.email,
      subject: "jam.coop - #{@newsletter.title}",
      track_opens: 'true',
      message_stream: 'broadcast'
    )
  end
end
