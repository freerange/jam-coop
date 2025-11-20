# frozen_string_literal: true

require 'test_helper'

class LabelTest < ActiveSupport::TestCase
  test 'factory is valid' do
    assert build(:label).valid?
  end

  test 'is invalid without a name' do
    label = build(:label, name: nil)
    assert_not label.valid?
  end

  test 'uses a friendly id' do
    label = create(:label, name: 'Jam Records')

    assert_equal label, Label.friendly.find('jam-records')
  end
end
