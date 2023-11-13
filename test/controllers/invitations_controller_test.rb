# frozen_string_literal: true

require 'test_helper'

class InvitationsControllerTestSignedIn < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(create(:user))
  end

  test '#new' do
    get new_invitation_url
    assert_response :success
  end

  test '#create creates a new user' do
    assert_changes('User.count') do
      post invitations_url, params: { email: 'alice@example.com' }
    end
  end

  test '#create associates new user with passed in artist' do
    artist = create(:artist)
    post invitations_url, params: { email: 'alice@example.com', artist_id: artist.id }

    assert_equal [artist], User.last.artists
  end

  test '#create sends an invitation email' do
    assert_emails 1 do
      post invitations_url, params: { email: 'alice@example.com' }
    end
  end

  test '#create redirects to home' do
    post invitations_url, params: { email: 'alice@example.com' }
    assert_redirected_to home_path
  end

  test '#create renders new if user cannot be created' do
    post invitations_url, params: { email: '' }
    assert_response :unprocessable_entity
  end
end

class InvitationsControllerTestSignedOut < ActionDispatch::IntegrationTest
  test '#new' do
    get new_invitation_url
    assert_redirected_to sign_in_path
  end

  test '#create' do
    post invitations_url, params: { email: 'alice@example.com' }
    assert_redirected_to sign_in_path
  end
end
