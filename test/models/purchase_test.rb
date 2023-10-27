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

  test '#price_in_pence' do
    purchase = build(:purchase, price: '3.45')

    assert_equal 345, purchase.price_in_pence
  end
end
