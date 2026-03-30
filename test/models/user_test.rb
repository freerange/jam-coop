# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
  end

  test 'does not suppress sending by default' do
    assert_not @user.suppress_sending?
  end

  test 'suppresses sending if sending_suppressed_at is blank' do
    @user.sending_suppressed_at = nil
    assert_not @user.suppress_sending?
  end

  test 'suppresses sending if sending_suppressed_at is present' do
    @user.sending_suppressed_at = Time.current
    assert @user.suppress_sending?
  end

  test 'is signed in' do
    assert @user.signed_in?
  end

  test 'collection includes completed purchases' do
    complete_purchase = create(:purchase, user: @user, completed: true)
    create(:purchase, user: @user, completed: false)

    assert_equal [complete_purchase], @user.collection
  end

  test '#owns?' do
    owned_album = create(:purchase, completed: true, user: @user).album
    incomplete_purchase = create(:purchase, completed: false, user: @user).album
    not_owned_album = create(:album)

    assert @user.owns?(owned_album)
    assert_not @user.owns?(incomplete_purchase)
    assert_not @user.owns?(not_owned_album)
  end

  test 'associates existing purchases with this user when email verified' do
    user = create(:user, verified: false)
    purchase = create(:purchase, customer_email: user.email)
    assert_nil purchase.user

    user.update(verified: true)
    assert_equal user, purchase.reload.user
  end

  test 'does not associate existing purchases with this user when email unverified' do
    user = create(:user, verified: true)
    purchase = create(:purchase, customer_email: user.email)
    assert_nil purchase.user

    user.update(verified: false)
    assert_nil purchase.reload.user
  end

  test '#followed_artists' do
    user = create(:user)
    artist = create(:artist)
    create(:following, user:, artist:)

    assert_equal [artist], user.reload.followed_artists
  end

  test '#follow creates a following between the user and artist' do
    user = create(:user)
    artist = create(:artist)
    user.follow(artist)

    assert_not_nil Following.find_by(user:, artist:)
  end

  test '#following?' do
    user = create(:user)
    artist = create(:artist)
    create(:following, user:, artist:)

    assert user.following?(artist)
  end

  test '#unfollow' do
    user = create(:user)
    artist = create(:artist)
    create(:following, user:, artist:)

    user.unfollow(artist)

    assert_nil Following.find_by(user:, artist:)
  end

  test '#stripe_connect_enabled? defaults to false' do
    user = build(:user)
    assert_not user.stripe_connect_enabled?
  end

  test '#stripe_connect_enabled? can be set to true' do
    user = build(:user, stripe_connect_enabled: true)
    assert user.stripe_connect_enabled?
  end

  test 'can have associated StripeConnectAccount' do
    user = create(:user)
    attributes = attributes_for(:stripe_connect_account)
    user.create_stripe_connect_account!(attributes)
    assert_equal attributes[:stripe_identifier], user.stripe_connect_account.stripe_identifier
  end

  test 'destroys associated StripeConnectAccount on destruction' do
    stripe_connect_account = build(:stripe_connect_account)
    user = create(:user, stripe_connect_account:)
    user.destroy!
    assert_not StripeConnectAccount.exists?(id: stripe_connect_account.id)
  end

  test 'has many payouts' do
    payouts = build_list(:payout, 2)
    user = create(:user, payouts:)
    assert_equal payouts, user.payouts
  end

  test 'destroys dependent payouts on destruction' do
    payouts = build_list(:payout, 2)
    user = create(:user, payouts:)
    user.destroy!
    assert payouts.all?(&:destroyed?)
  end
end
