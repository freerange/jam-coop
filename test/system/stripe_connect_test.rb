# frozen_string_literal: true

require 'application_system_test_case'

class StripeConnectTest < ApplicationSystemTestCase
  test 'after enabling Stripe Connect on my account, a customer purchases one of my albums' do
    stub_stripe_connect_user_flow

    using_session('artist') do
      log_in_as(artist_user)
      visit account_path

      click_on 'Connect Stripe'

      assert_equal account_path, current_path
      assert_text "Account ID: #{stripe_account_id}"
      assert_text 'Your Stripe account is connected'
    end

    create_published_album
    stub_stripe_checkout_flow

    using_session('fan') do
      visit artist_album_path(album.artist, album)
      click_on 'Buy'
      fill_in 'Price', with: album.price
      click_on 'Checkout'

      perform_enqueued_jobs

      visit purchase_path(purchase)
      assert_text 'Thank you!'
      assert_text 'Download (mp3v0)'
    end

    assert_equal album.price, purchase.price
    assert_equal amount_tax, purchase.amount_tax
  end

  private

  def stripe_account_id
    'acct_id'
  end

  def stub_stripe_connect_user_flow
    Stripe::Account.stubs(:create).returns(
      stub('Stripe::Account', id: stripe_account_id)
    )
    Stripe::AccountLink.stubs(:create).with(
      has_entry(account: stripe_account_id)
    ).returns(
      stub('Stripe::AccountLink', url: success_stripe_connect_account_url(stripe_account_id))
    )
    Stripe::Account.stubs(:retrieve).with(stripe_account_id).returns(
      stub('Stripe::Account', details_submitted?: true, charges_enabled?: true, payouts_enabled?: false)
    )
  end

  def stub_stripe_checkout_flow
    Stripe::Checkout::Session.stubs(:create).returns(stripe_checkout_session)
    Stripe::Checkout::Session.stubs(:retrieve).with(stripe_session_id).returns(stripe_checkout_session)
    Stripe::PaymentIntent.stubs(:retrieve).with(payment_intent_id).returns(stripe_payment_intent)
    PurchaseCompleteJob.perform_later(stripe_session_id)
  end

  def stripe_checkout_session
    Stripe::Checkout::Session.construct_from(
      id: stripe_session_id,
      url: 'https://stripe.example.com',
      customer_details: {
        email: 'fan@example.com'
      },
      total_details: {
        amount_tax:
      },
      payment_intent: payment_intent_id
    )
  end

  def stripe_session_id
    'cs_test_foo'
  end

  def stripe_payment_intent
    Stripe::PaymentIntent.construct_from(
      id: payment_intent_id,
      application_fee_amount:,
      transfer_data: {
        destination: stripe_account_id,
        amount:
      }
    )
  end

  def payment_intent_id
    'pi_test_foo'
  end

  def tax_percent
    20
  end

  def amount
    album.price * 100
  end

  def amount_tax
    album.price * 100 * tax_percent / 100.0
  end

  def application_fee_amount
    album.price * 100 * Rails.configuration.platform_fee_percentage / 100.0
  end

  def artist_user
    @artist_user ||= create(:user, stripe_connect_enabled: true)
  end

  def artist
    @artist ||= create(:artist, user: artist_user)
  end

  def album
    @album ||= create(:published_album, :with_tracks, artist:, price: 7.00)
  end

  def create_published_album
    create(:transcode, track: album.tracks.first)
  end

  def purchase
    Purchase.last
  end
end
