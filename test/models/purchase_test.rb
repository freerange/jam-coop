# frozen_string_literal: true

require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test 'factory is valid' do
    assert build(:purchase).valid?
  end

  test 'is invalid if price is less than the albums suggested price' do
    album = build(:album, price: '5.00')
    purchase = build(:purchase, album:, price: '3.00')

    assert_not purchase.valid?
    assert purchase.errors[:price].include? 'Price must be more than £5.00'
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

  test '#platform_fee_in_pence returns the amount we charge the artist' do
    album = build(:album, price: '10.00')
    purchase = build(:purchase, album:, price: '20.00')
    platform_fee_fraction = Rails.configuration.platform_fee_percentage / 100.0
    expected_fee_in_pence = (purchase.price_excluding_gratuity_in_pence * platform_fee_fraction).to_i

    assert_equal expected_fee_in_pence, purchase.platform_fee_in_pence
  end
end
