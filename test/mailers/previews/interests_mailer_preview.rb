# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/interests_mailer
class InterestsMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/interests_mailer/confirm
  def confirm
    interest = Interest.find_or_create_by(email: 'chris@example.com')
    InterestsMailer.confirm(interest)
  end
end
