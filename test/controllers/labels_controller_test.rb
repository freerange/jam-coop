# frozen_string_literal: true

require 'test_helper'

class LabelsControllerTestSignedInAsLabelOwner < ActionDispatch::IntegrationTest
  setup do
    user = create(:user)
    log_in_as(user)
    @label = create(:label, user:)
    artist = create(:artist, user:)
    @published_album = create(:published_album, title: 'Published album', artist:)
    @draft_album = create(:draft_album, title: 'Draft album', artist:)
    create(:release, label: @label, album: @published_album)
    create(:release, label: @label, album: @draft_album)
  end

  test '#show' do
    get label_path(@label)
    assert_response :success
  end

  test '#show includes published albums' do
    get label_path(@label)
    assert_select 'p', @published_album.title
  end

  test '#show includes draft albums' do
    get label_path(@label)
    assert_select 'p', @draft_album.title
  end
end

class LabelsControllerTestSignedOut < ActionDispatch::IntegrationTest
  setup do
    @label = create(:label)
    @published_album = create(:published_album, title: 'Published album')
    @draft_album = create(:draft_album, title: 'Draft album')
    create(:release, label: @label, album: @published_album)
    create(:release, label: @label, album: @draft_album)
  end

  test '#show' do
    get label_path(@label)
    assert_response :success
  end

  test '#show includes published albums' do
    get label_path(@label)
    assert_select 'p', @published_album.title
  end

  test '#show exludes draft albums' do
    get label_path(@label)
    assert_select 'p', { text: @draft_album.title, count: 0 }
  end
end
