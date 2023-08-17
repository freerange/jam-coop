# frozen_string_literal: true

require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  test 'fixture is valid' do
    assert build(:album).valid?
  end

  test 'uses a friendly id' do
    album = create(:album, title: 'Who? What? Where?')

    assert_equal album, Album.friendly.find('who-what-where')
  end
end
