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
    owned_album = create(:purchase, user: @user).album
    not_owned_album = create(:album)

    assert @user.owns?(owned_album)
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
end
