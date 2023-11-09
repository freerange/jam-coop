# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/broadcast_mailer
class BroadcastMailerPreview < ActionMailer::Preview
  def newsletter
    user = User.create_with(password: SecureRandom.hex).find_or_create_by!(email: 'helen@example.com')
    BroadcastMailer.newsletter(user)
  end
end
