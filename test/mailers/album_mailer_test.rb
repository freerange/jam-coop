# frozen_string_literal: true

require 'test_helper'

class AlbumMailerTest < ActionMailer::TestCase
  setup do
    @album = create(:album)
  end

  test 'request_publication' do
    mail = AlbumMailer.with(album: @album).request_publication
    assert_equal "#{@album.artist.name} has requested publication of #{@album.title}", mail.subject
    assert_equal ['contact@jam.coop'], mail.to
  end
end
