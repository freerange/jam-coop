# frozen_string_literal: true

require 'application_system_test_case'

class PublishingAnAlbumTest < ApplicationSystemTestCase
  setup do
    @album = create(:unpublished_album, :with_tracks)
    user = create(:user)
    user.artists << @album.artist
    log_in_as(user)
  end

  test 'publishing an album' do
    # Album does not appear in "recently released" section
    visit root_url
    within(recently_released) do
      refute_text @album.title
    end

    # Artist requests publication
    visit artist_url(@album.artist)
    click_on @album.title.to_s
    click_on 'Publish'
    assert_text "Thank you! We'll email you when your album is published."
    sign_out

    # Admin approves publication
    admin = create(:user, admin: true, email: 'admin@example.com')
    log_in_as(admin)
    visit link_in_publish_request_email
    click_on 'Publish'
    sign_out

    # Listener visits published album page
    visit artist_url(@album.artist)
    click_on @album.title

    # Album appears in "recently released" section
    visit root_url
    within(recently_released) do
      assert_text @album.title
    end
  end

  private

  def link_in_publish_request_email
    perform_enqueued_jobs

    mail = ActionMailer::Base.deliveries.last

    url = /"(?<url>http.*artists.*albums.*)"/.match(mail.to_s).named_captures['url']
    url.gsub('http://example.com/', root_url)
  end

  def recently_released
    find('h2', text: 'Recently released').ancestor('section')
  end
end
