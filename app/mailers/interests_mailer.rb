# frozen_string_literal: true

class InterestsMailer < ApplicationMailer
  def confirm(interest)
    return if interest.suppress_sending?

    @interest = interest

    mail(
      to: interest.email,
      subject: 'Confirm your email address',
      track_opens: 'true',
      message_stream: 'outbound'
    )
  end
end
