# frozen_string_literal: true

require 'application_system_test_case'

class AdministeringALabelTest < ApplicationSystemTestCase
  setup do
    @user = create(:user)
    log_in_as(@user)
  end

  test 'creating a new label' do
    visit account_path
    click_on 'Add label'
    fill_in 'Name', with: 'Jam Records'
    fill_in 'Location', with: 'London, United Kingdom'
    fill_in 'Description', with: 'Jam Records is the in-house record label for jam.coop'
    attach_file 'Logo', Rails.root.join('test/fixtures/files/cover.png')

    click_on 'Save'
    assert_text 'Label was successfully created'
  end

  test 'editing an existing label' do
    label = create(:label, user: @user)

    visit account_path
    click_on label.name
    fill_in 'Name', with: 'A new name'

    click_on 'Save'
    assert_text 'Label was successfully updated'
  end

  test 'adding a release to a label' do
    artist = create(:artist, user: @user)
    create(:published_album, artist:, title: 'album-name')
    label = create(:label, user: @user)

    visit account_path
    click_on label.name
    click_on 'Add release'
  end
end
