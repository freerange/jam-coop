# frozen_string_literal: true

require 'test_helper'

class PurchasePolicyTest < ActiveSupport::TestCase
  test '#index? returns true if user signed in' do
    user = build(:user)

    policy = PurchasePolicy.new(user, Purchase.all)
    assert policy.index?
  end

  test '#index? returns false if user not signed in' do
    user = NullUser.new

    policy = PurchasePolicy.new(user, Purchase.all)
    assert_not policy.index?
  end

  test 'scope includes all purchases when user is admin' do
    user = create(:user, admin: true)
    artist = create(:artist, user:)
    album = create(:album, artist: artist)
    purchase = create(:purchase, album:, price: album.price)
    purchase_from_another_seller = create(:purchase)

    scope = PurchasePolicy::Scope.new(user, Purchase.all)

    assert_includes scope.resolve, purchase
    assert_includes scope.resolve, purchase_from_another_seller
  end

  test 'scope only includes purchases sold by user when user is not admin' do
    user = create(:user)
    artist = create(:artist, user:)
    album = create(:album, artist: artist)
    purchase = create(:purchase, album:, price: album.price)
    purchase_from_another_seller = create(:purchase)

    scope = PurchasePolicy::Scope.new(user, Purchase.all)

    assert_includes scope.resolve, purchase
    assert_not_includes scope.resolve, purchase_from_another_seller
  end
end
