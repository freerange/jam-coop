# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'accounts+postmark@gofreerange.com'

  layout 'mailer'
end
