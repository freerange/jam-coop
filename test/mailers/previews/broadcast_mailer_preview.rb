# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/broadcast_mailer
class BroadcastMailerPreview < ActionMailer::Preview
  def newsletter
    user = User.create_with(password: SecureRandom.hex).find_or_create_by!(email: 'helen@example.com')
    newsletter = Newsletter.build(title: 'Newsletter preview', body:)

    BroadcastMailer.newsletter(user, newsletter)
  end

  private

  def body
    <<~MARKDOWN
      Hello!

      This is a preview newsletter. It includes some markdown, like [this link](https://example.com).

      ## And this heading

      Goodbye!
    MARKDOWN
  end
end
