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
end
