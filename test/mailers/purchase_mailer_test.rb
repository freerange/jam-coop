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

  test 'notify_artist with Stripe payout associated with purchase' do
    stripe_connect_account = build(:stripe_connect_account, charges_enabled: true)
    user = build(:user, stripe_connect_account:)
    album = build(:album)
    user.artists << album.artist
    payout = build(:stripe_payout, amount_in_pence: 550, platform_fee_in_pence: 150)
    purchase = build(:purchase, album:, price: 7.00, payout:)

    mail = PurchaseMailer.with(purchase:).notify_artist

    assert_equal "You have sold a copy of #{album.title}", mail.subject
    assert_equal [user.email], mail.to
    assert_includes mail.body.to_s, 'for £7.00'
    assert_includes mail.body.to_s, 'A payment of £5.50 has been made to your'
    assert_includes mail.body.to_s, link_stripe_connect_account_url(stripe_connect_account.stripe_identifier)
    assert_includes mail.body.to_s, 'A platform fee of £1.50 was deducted.'
    assert_includes mail.body.to_s, 'Other Stripe fees may have been incurred (e.g. currency conversion fees).'
  end

  test 'notify_artist with connected Stripe account not accepting payments' do
    stripe_connect_account = build(:stripe_connect_account, details_submitted: true)
    user = build(:user, stripe_connect_account:)
    album = build(:album)
    user.artists << album.artist
    purchase = build(:purchase, album:, price: 7.00)

    mail = PurchaseMailer.with(purchase:).notify_artist

    assert_includes mail.body.to_s, "You've started connecting"
    assert_includes mail.body.to_s, link_stripe_connect_account_url(stripe_connect_account.stripe_identifier)
    assert_includes mail.body.to_s, "but it's not yet ready to receive payments"
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
