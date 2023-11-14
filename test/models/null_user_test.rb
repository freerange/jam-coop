# frozen_string_literal: true

require 'test_helper'

class NullUserTest < ActiveSupport::TestCase
  setup do
    @user = NullUser.new
  end

  test 'is not an admin' do
    assert_not @user.admin?
  end
end
