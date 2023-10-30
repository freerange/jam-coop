# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/broadcast_mailer
class BroadcastMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/broadcast_mailer/test
  def test
    user = User.create_with(password: SecureRandom.hex).find_or_create_by!(email: 'helen@example.com')
    BroadcastMailer.test(user)
  end
end
