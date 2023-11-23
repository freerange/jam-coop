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

  test '#published' do
    user = create(:user)
    user.artists << @album.artist
    mail = AlbumMailer.with(album: @album).published

    assert_equal [user.email], mail.to
    assert_equal "Your album #{@album.title} has been published", mail.subject
  end

  test '#published does not send email if album has no associated user' do
    AlbumMailer.with(album: @album).published
    assert_emails 0
  end

  test '#published does not send email if associated user has sending suppressed' do
    user = create(:user, sending_suppressed_at: Time.current)
    user.artists << @album.artist
    AlbumMailer.with(album: @album).published
    assert_emails 0
  end
end
