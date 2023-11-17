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

  test 'notify_artist' do
    user = build(:user)
    album = build(:album)
    user.artists << album.artist
    purchase = build(:purchase, album:, price: 7.00)

    mail = PurchaseMailer.with(purchase:).notify_artist

    assert_equal "You have sold a copy of #{album.title}", mail.subject
    assert_equal [user.email], mail.to
    assert_includes mail.body.to_s, 'for £7.00'
  end

  test 'notify_artist does not send if the artist has no associated user' do
    album = build(:album)
    purchase = build(:purchase, album:, price: 7.00)

    PurchaseMailer.with(purchase:).notify_artist
    assert_emails 0
  end
end
