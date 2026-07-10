# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/broadcast_mailer
class BroadcastMailerPreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods

  # Preview this email at http://localhost:3000/rails/mailers/broadcast_mailer/newsletter
  def newsletter
    recipient = build(:user)
    newsletter = build(:newsletter)

    BroadcastMailer.with(recipient:, newsletter:).newsletter
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
