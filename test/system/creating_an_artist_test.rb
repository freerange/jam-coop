# frozen_string_literal: true

require 'application_system_test_case'

class CreatingAnArtistTest < ApplicationSystemTestCase
  setup do
    user = create(:user)

    log_in_as(user)
  end

  test 'creating an artist' do
    visit root_url
    click_on 'avatar'
    click_on 'Add artist'
    fill_in 'Name', with: 'The Beatles'
    fill_in 'Location', with: 'Liverpool'
    fill_in 'Description', with: 'A popular beat combo'
    attach_file 'Profile picture', Rails.root.join('test/fixtures/files/cover.png')

    click_on 'Save'

    assert_text 'The Beatles'
    assert_text 'Liverpool'
    assert_text 'A popular beat combo'
  end
end
