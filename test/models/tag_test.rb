# frozen_string_literal: true

require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test 'factory is valid' do
    assert build(:tag).valid?
  end
end
