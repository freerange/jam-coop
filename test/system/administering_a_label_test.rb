# frozen_string_literal: true

require 'application_system_test_case'

class AdministeringALabelTest < ApplicationSystemTestCase
  setup do
    @user = create(:user, labels_enabled: true)
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
    select 'album-name', from: 'Album'
    click_on 'Save release'

    within(release_section) do
      assert_text 'album-name'
      assert_text artist.name
    end
  end

  test 'editing an existing release' do
    artist = create(:artist, user: @user)
    album = create(:published_album, artist:, title: 'album-name')
    create(:published_album, artist:, title: 'other-album')
    label = create(:label, user: @user)
    create(:release, label:, album:)

    visit account_path
    click_on label.name

    within(release_section) do
      assert_text 'album-name'
      refute_text 'other-album'
    end

    click_on 'album-name'
    select 'other-album', from: 'Album'
    click_on 'Save release'

    within(release_section) do
      assert_text 'other-album'
      refute_text 'album-name'
    end
  end

  test 'removing an existing release' do
    artist = create(:artist, user: @user)
    album = create(:published_album, artist:, title: 'album-name')
    label = create(:label, user: @user)
    create(:release, label:, album:)

    visit account_path
    click_on label.name

    within(release_section) do
      assert_text 'album-name'
    end

    click_on 'album-name'

    accept_alert 'Are you sure you want to remove this release?' do
      click_on 'Remove release'
    end

    within(release_section) do
      refute_text 'album-name'
    end
  end

  private

  def release_section
    find('h2', text: 'Release').ancestor('.sidebar-section')
  end
end
