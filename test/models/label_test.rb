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

  test 'is not valid if logo is not an image' do
    label = build(:label)

    label.logo.attach(
      io: Rails.root.join('test/fixtures/files/dummy.pdf').open,
      filename: 'dummy.pdf',
      content_type: 'application/pdf'
    )

    assert_not label.valid?
    assert_includes label.errors[:logo], 'must be an image file (jpeg, png)'
  end
end
