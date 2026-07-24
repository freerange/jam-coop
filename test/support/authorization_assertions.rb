# frozen_string_literal: true

module AuthorizationAssertions
  def assert_not_authorized
    assert_redirected_to root_path
    assert_equal 'You are not authorized to perform this action.', flash[:alert]
  end
end
