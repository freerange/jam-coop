# frozen_string_literal: true

require 'test_helper'

class PurchaseMailerTest < ActionMailer::TestCase
  test 'purchase_completed' do
    album = create(:album)
    purchase = create(:purchase, album:, price: album.price, customer_email: 'email@example.com')

    mail = PurchaseMailer.with(purchase:).completed

    assert_equal "Thank you for purchasing #{album.title}", mail.subject
    assert_equal ['email@example.com'], mail.to
  end
end
