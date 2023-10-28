# frozen_string_literal: true

require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  test 'fixture is valid' do
    assert build(:artist).valid?
  end

  test '.listed' do
    listed_artist = create(:artist, name: 'Listed', listed: true)
    create(:artist, name: 'Unlisted', listed: false)

    assert_equal [listed_artist], Artist.listed
  end

  test 'uses a friendly id' do
    artist = create(:artist, name: 'Rick Astley')

    assert_equal artist, Artist.friendly.find('rick-astley')
  end
end
