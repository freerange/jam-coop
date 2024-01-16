# frozen_string_literal: true

require 'application_system_test_case'

class PublishingAnAlbumTest < ApplicationSystemTestCase
  setup do
    @album = create(:unpublished_album)
    user = create(:user)
    user.artists << @album.artist
    log_in_as(user)
  end

  test 'publishing an album' do
    # Artist requests publication
    visit artist_url(@album.artist)
    click_link "#{@album.title} (unpublished)"
    click_button 'Publish'
    assert_text "Thank you! We'll email you when your album is published."
    sign_out

    # Admin approves publication
    admin = create(:user, admin: true, email: 'admin@example.com')
    log_in_as(admin)
    visit link_in_publish_request_email
    click_button 'Publish'
    sign_out

    # Listener visits published album page
    visit artist_url(@album.artist)
    click_link @album.title
  end

  private

  def link_in_publish_request_email
    perform_enqueued_jobs

    mail = ActionMailer::Base.deliveries.last

    url = /"(?<url>http.*artists.*albums.*)"/.match(mail.to_s).named_captures['url']
    url.gsub('http://example.com/', root_url)
  end
end
