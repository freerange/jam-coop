# frozen_string_literal: true

require 'application_system_test_case'

class CollectionTest < ApplicationSystemTestCase
  setup do
    @user = create(:user)
    @album = create(:published_album)
    stub_stripe_checkout_session
  end

  test 'when a logged in user purchases an album it appears in their collection' do
    log_in_as(@user)
    visit artist_album_path(@album.artist, @album)
    click_on 'Buy'
    fill_in 'Price', with: @album.price
    click_on 'Checkout'
    fake_stripe_webhook_event_completed(@user)
    visit collection_path
    assert_text @album.title
    click_on @album.title
    assert_text 'You own this album'
  end

  test 'when a logged out user purchases an album it appears in their collection' do
    visit artist_album_path(@album.artist, @album)
    click_on 'Buy'
    fill_in 'Price', with: @album.price
    click_on 'Checkout'
    fake_stripe_webhook_event_completed(@user)

    log_in_as(@user)
    visit collection_path
    assert_text @album.title
  end

  test 'when someone purchases an album and then creates an account, the album appears in their collection' do
    user = build(:user, email: 'someone@example.com')

    visit artist_album_path(@album.artist, @album)
    click_on 'Buy'
    fill_in 'Price', with: @album.price
    click_on 'Checkout'
    fake_stripe_webhook_event_completed(user)

    visit root_path
    click_on 'sign up'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'Secret1*3*5*'
    fill_in 'Password confirmation', with: 'Secret1*3*5*'
    perform_enqueued_jobs do
      click_on 'Sign up'
    end
    visit verify_email_url
    assert_text 'Thank you for verifying your email address'

    visit collection_path
    assert_text @album.title
  end

  private

  def fake_stripe_webhook_event_completed(user)
    amount_tax = 0
    PurchaseCompleteJob.perform_now('cs_test_foo', user.email, amount_tax)
  end
end
