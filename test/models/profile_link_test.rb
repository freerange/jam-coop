# frozen_string_literal: true

require 'test_helper'

class ProfileLinkTest < ActiveSupport::TestCase
  test 'factory is valid' do
    assert build(:profile_link).valid?
  end

  test 'is invalid without a URL' do
    profile_link = build(:profile_link, url: nil)

    assert_not profile_link.valid?
  end
end
