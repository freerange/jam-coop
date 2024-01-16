# frozen_string_literal: true

require 'test_helper'

module Admin
  class AlbumPolicyTest < ActiveSupport::TestCase
    test 'an admin' do
      user = build(:user, admin: true)
      album = build(:album)
      policy = Admin::AlbumPolicy.new(user, album)

      assert policy.index?
    end
  end
end
