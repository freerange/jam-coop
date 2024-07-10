# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name('contact@jam.coop', 'Jam')

  layout 'mailer'
end
