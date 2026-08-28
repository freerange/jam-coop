# frozen_string_literal: true

require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test 'factory is valid' do
    assert build(:tag).valid?
  end

  test 'uses a friendly id' do
    tag = create(:tag, name: 'rock')

    assert_equal tag, Tag.find('rock')
  end
end
