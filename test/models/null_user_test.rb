# frozen_string_literal: true

require 'test_helper'

class NullUserTest < ActiveSupport::TestCase
  setup do
    @user = NullUser.new
  end

  test 'is not an admin' do
    assert_not @user.admin?
  end

  test 'is not signed in' do
    assert_not @user.signed_in?
  end
end
