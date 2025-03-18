# frozen_string_literal: true

require 'application_system_test_case'

class StripeConnectTest < ApplicationSystemTestCase
  test 'after enabling Stripe Connect on my account, a customer purchases one of my albums' do
    stub_stripe_connect_user_flow

    log_in_as(artist_user)
    visit account_path

    click_on 'Setup Stripe Connect'

    assert_equal account_path, current_path
    assert_text stripe_account_id
    assert_text 'Charges enabled'

    create_published_album
    stub_stripe_purchase_service

    visit artist_album_path(album.artist, album)
    click_on 'Buy'
    fill_in 'Price', with: album.price
    click_on 'Checkout'

    perform_enqueued_jobs

    visit purchase_path(Purchase.last)
    assert_text 'Thank you!'
    assert_text 'Download (mp3v0)'
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
      stub('Stripe::Account', details_submitted?: true, charges_enabled?: true)
    )
  end

  def stub_stripe_purchase_service
    service = stub(create_checkout_session: stub(success?: true, url: 'https://stripe.example.com', id: 'cs_test_foo'))
    StripeService.expects(:new).returns(service)
  end

  def artist_user
    @artist_user ||= create(:user)
  end

  def artist
    @artist ||= create(:artist, user: artist_user)
  end

  def album
    @album ||= create(:published_album, :with_tracks, artist:)
  end

  def create_published_album
    create(:transcode, track: album.tracks.first)
  end
end
