# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/interests_mailer
class InterestsMailerPreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods

  # Preview this email at http://localhost:3000/rails/mailers/interests_mailer/confirm
  def confirm
    interest = build_stubbed(:interest)
    InterestsMailer.confirm(interest)
  end
end
