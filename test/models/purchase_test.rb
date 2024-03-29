# frozen_string_literal: true

require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase
  test 'fixture is valid' do
    assert build(:purchase).valid?
  end

  test 'is invalid if price is less than the albums suggested price' do
    album = create(:album, price: '5.00')
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
end
