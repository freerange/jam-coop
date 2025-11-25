# frozen_string_literal: true

require 'test_helper'

class StripeTransferTest < ActiveSupport::TestCase
  setup do
    @transfer = build(:stripe_transfer)
  end

  test 'factory is valid' do
    assert @transfer.valid?
  end

  test 'is invalid without Stripe account' do
    @transfer.stripe_account = nil
    assert_not @transfer.valid?
  end

  test 'is invalid without purchase' do
    @transfer.purchase = nil
    assert_not @transfer.valid?
  end

  test 'is invalid without amount in pence' do
    @transfer.amount_in_pence = nil
    assert_not @transfer.valid?
  end
end
