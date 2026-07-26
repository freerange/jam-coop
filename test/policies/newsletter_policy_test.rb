# frozen_string_literal: true

require 'test_helper'

class NewsletterPolicyTest < ActiveSupport::TestCase
  test 'an admin user can view all newsletters' do
    user = build(:user, admin: true)
    unpublished_newsletter = create(:newsletter, published_at: nil)
    published_newsletter = create(:newsletter, published_at: Time.current)

    scope = NewsletterPolicy::Scope.new(user, Newsletter.all)

    assert_includes scope.resolve, unpublished_newsletter
    assert_includes scope.resolve, published_newsletter
  end

  test 'a non-admin user can only view published newsletters' do
    user = build(:user)
    unpublished_newsletter = create(:newsletter, published_at: nil)
    published_newsletter = create(:newsletter, published_at: Time.current)

    scope = NewsletterPolicy::Scope.new(user, Newsletter.all)

    assert_not_includes scope.resolve, unpublished_newsletter
    assert_includes scope.resolve, published_newsletter
  end
end
