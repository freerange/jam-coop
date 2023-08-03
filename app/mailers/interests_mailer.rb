# frozen_string_literal: true

class InterestsMailer < ApplicationMailer
  def confirm(interest)
    @interest = interest

    mail to: interest.email, subject: 'Confirm your email address'
  end
end
