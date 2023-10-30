# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
  end

  test 'does not suppress sending by default' do
    assert_not @user.suppress_sending?
  end

  test 'suppresses sending if hard bounce has occurred' do
    create(:hard_bounce, user: @user)
    assert @user.suppress_sending?
  end

  test 'suppresses sending if manual suppression has occurred' do
    create(:manual_suppression, user: @user)
    assert @user.suppress_sending?
  end

  test 'does not suppress sending if manual reactivation has occurred' do
    freeze_time do
      create(:manual_reactivation, user: @user, changed_at: 1.hour.ago)
      create(:hard_bounce, user: @user, changed_at: 2.hours.ago)
    end
    assert_not @user.suppress_sending?
  end
end
