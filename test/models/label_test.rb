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

    assert_equal label, Label.find('jam-records')
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

  test '.with_albums' do
    album = create(:album)
    label_with_albums = create(:label)
    create(:release, album:, label: label_with_albums)
    label_without_albums = create(:label)

    scope = Label.with_albums

    assert_includes scope, label_with_albums
    assert_not_includes scope, label_without_albums
  end

  test 'featured' do
    create(:label)
    featured_label = create(:label, featured: true)

    assert_equal [featured_label], Label.featured
  end
end
