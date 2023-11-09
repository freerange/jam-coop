# frozen_string_literal: true

class BroadcastMailer < ApplicationMailer
  def newsletter(user)
    return if user.suppress_sending?

    mail(
      to: user.email,
      from: email_address_with_name('contact@jam.coop', 'Chris (jam.coop)'),
      subject: 'jam.coop - Newsletter #1',
      track_opens: 'true',
      message_stream: 'broadcast'
    )
  end
end
