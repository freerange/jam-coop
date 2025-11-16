# frozen_string_literal: true

require 'test_helper'

class PurchaseMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers

  test 'purchase_completed' do
    album = build(:album)
    purchase = build_stubbed(:purchase, album:, price: album.price, customer_email: 'email@example.com')

    mail = PurchaseMailer.with(purchase:).completed

    assert_equal "Thank you for purchasing #{album.title}", mail.subject
    assert_equal ['email@example.com'], mail.to
  end

  test 'do not send purchase completed email if sending is suppressed' do
    purchase = build(:purchase, customer_email: 'email@example.com', sending_suppressed_at: Time.current)
    PurchaseMailer.with(purchase:).completed.deliver_now!
    assert_emails 0
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
    artist = build(:artist, user: nil)
    album = build(:album, artist:)
    purchase = build(:purchase, album:, price: 7.00)

    PurchaseMailer.with(purchase:).notify_artist.deliver_now!
    assert_emails 0
  end

  test 'notify_artist asks user to complete payout details' do
    user = build(:user)
    album = build(:album)
    user.artists << album.artist
    purchase = build(:purchase, album:, price: 7.00)

    mail = PurchaseMailer.with(purchase:).notify_artist
    assert_includes mail.body.to_s, account_url
  end

  test 'notify_artist allows user to change/verify payout details' do
    user = build(:user)
    build(:payout_detail, user:)
    album = build(:album)
    user.artists << album.artist
    purchase = build(:purchase, album:, price: 7.00)

    mail = PurchaseMailer.with(purchase:).notify_artist
    assert_includes mail.body.to_s, account_url
  end

  test 'do not notify artist of purchase if sending is suppressed' do
    user = build(:user, sending_suppressed_at: Time.current)
    album = build(:album)
    user.artists << album.artist
    purchase = build(:purchase, album:, price: 7.00)

    PurchaseMailer.with(purchase:).notify_artist.deliver_now!
    assert_emails 0
  end
end
