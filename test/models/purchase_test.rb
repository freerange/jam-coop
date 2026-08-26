# frozen_string_literal: true

require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test 'factory is valid' do
    assert build(:purchase).valid?
  end

  test 'is invalid if price is less than the albums suggested price on creation' do
    album = build(:album, price: '5.00')
    purchase = build(:purchase, album:, price: '3.00')

    assert_not purchase.save
    assert purchase.errors[:price].include? 'must be more than £5.00'
  end

  test 'is valid if price is less than the albums suggested price on update' do
    album = build(:album, price: '5.00')
    purchase = create(:purchase, album:, price: '5.00')

    assert purchase.update(price: '3.00')
  end

  test '#price_in_pence' do
    purchase = build(:purchase, price: 7.00)
    assert_equal 700, purchase.price_in_pence
  end

  test '#price_excluding_gratuity is the album price excluding gratuity' do
    album = build(:album, price: '5.00')
    purchase_without_gratuity = build(:purchase, album:, price: '5.00')
    purchase_with_gratuity = build(:purchase, album:, price: '7.00')

    assert_equal 5.00, purchase_without_gratuity.price_excluding_gratuity
    assert_equal 5.00, purchase_with_gratuity.price_excluding_gratuity
  end

  test '#price_excluding_gratuity_in_pence is the album price excluding gratuity' do
    album = build(:album, price: '5.00')
    purchase_without_gratuity = build(:purchase, album:, price: '5.00')
    purchase_with_gratuity = build(:purchase, album:, price: '7.00')

    assert_equal 500, purchase_without_gratuity.price_excluding_gratuity_in_pence
    assert_equal 500, purchase_with_gratuity.price_excluding_gratuity_in_pence
  end

  test '#gratuity?' do
    album = build(:album, price: '5.00')
    purchase_without_gratuity = build(:purchase, album:, price: '5.00')
    purchase_with_gratuity = build(:purchase, album:, price: '7.00')

    assert_not purchase_without_gratuity.gratuity?
    assert purchase_with_gratuity.gratuity?
  end

  test '#gratuity' do
    album = build(:album, price: '5.00')
    purchase = build(:purchase, album:, price: '7.00')

    assert_equal 2.00, purchase.gratuity
  end

  test '#gratuity_in_pence' do
    album = build(:album, price: '5.00')
    purchase = build(:purchase, album:, price: '7.00')

    assert_equal 200, purchase.gratuity_in_pence
  end

  test 'create enqueues ZipDownloadJob to prepare mp3v0 download' do
    args_matcher = ->(job_args) { job_args[1][:format] == :mp3v0 }
    assert_enqueued_with(job: ZipDownloadJob, args: args_matcher) do
      create(:purchase)
    end
  end

  test 'create enqueues ZipDownloadJob to prepare flac download' do
    args_matcher = ->(job_args) { job_args[1][:format] == :flac }
    assert_enqueued_with(job: ZipDownloadJob, args: args_matcher) do
      create(:purchase)
    end
  end

  test '#platform_fee returns the amount we charge the artist' do
    album = build(:album, price: 10.00)
    purchase = build(:purchase, album:, price: 15.00)
    platform_fee_fraction = Rails.configuration.platform_fee_percentage / 100.0
    expected_fee = 15.00 * platform_fee_fraction

    assert_equal expected_fee, purchase.platform_fee
  end

  test '#platform_fee_in_pence returns the amount we charge the artist' do
    album = build(:album, price: 10.00)
    purchase = build(:purchase, album:, price: 15.00)
    platform_fee_fraction = Rails.configuration.platform_fee_percentage / 100.0
    expected_fee_in_pence = (1500 * platform_fee_fraction).to_i

    assert_equal expected_fee_in_pence, purchase.platform_fee_in_pence
  end

  test '#tax returns the amount of tax in pounds' do
    purchase = build(:purchase, amount_tax: 150)

    assert_equal 1.50, purchase.tax
  end

  test '#tax returns nil if amount of tax is nil' do
    purchase = build(:purchase, amount_tax: nil)

    assert_nil purchase.tax
  end

  test 'can be associated with a payout' do
    payout = build(:payout)
    purchase = create(:purchase, payout:)
    assert_equal payout, purchase.payout
  end

  test '.without_payout' do
    payout = build(:payout)
    purchase_with_payout = create(:purchase, payout:)
    purchase_without_payout = create(:purchase)
    purchases = Purchase.without_payout
    assert_includes purchases, purchase_without_payout
    assert_not_includes purchases, purchase_with_payout
  end

  test '#stripe_payout returns nil if no payout' do
    purchase_without_payout = build(:purchase)
    assert_nil purchase_without_payout.stripe_payout
  end

  test '#stripe_payout returns nil if payout is not stripe' do
    payout = build(:payout)
    purchase_with_non_stripe_payout = build(:purchase, payout:)
    assert_nil purchase_with_non_stripe_payout.stripe_payout
  end

  test '#stripe_payout returns payout if payout is stripe' do
    stripe_payout = build(:stripe_payout)
    purchase_with_stripe_payout = build(:purchase, payout: stripe_payout)
    assert_equal stripe_payout, purchase_with_stripe_payout.stripe_payout
  end

  test '.completed only returns completed purchases' do
    create(:purchase, completed: false)
    complete_purchase = create(:purchase, completed: true)
    assert_equal [complete_purchase], Purchase.completed
  end

  test '.for_seller' do
    user = create(:user)
    artist = create(:artist, user:)
    album = create(:album, artist: artist)
    purchase = create(:purchase, album:, price: album.price)
    purchase_from_another_seller = create(:purchase)

    relation = Purchase.for_seller(user)

    assert_includes relation, purchase
    assert_not_includes relation, purchase_from_another_seller
  end
end
