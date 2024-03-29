# frozen_string_literal: true

require 'test_helper'

class InterestTest < ActiveSupport::TestCase
  test 'new records have a confirm token' do
    interest = create(:interest)

    assert interest.confirm_token.present?
  end

  test '#email_activate sets email_confirmed to true' do
    interest = build(:interest)

    assert_not interest.email_confirmed

    interest.email_activate

    assert interest.email_confirmed
  end
end
