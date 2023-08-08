# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'contact@jam.coop'

  layout 'mailer'
end
