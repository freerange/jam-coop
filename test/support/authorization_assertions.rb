# frozen_string_literal: true

module AuthorizationAssertions
  def assert_not_authorized(redirected_to: root_path)
    assert_redirected_to redirected_to
    assert_equal 'You are not authorized to perform this action.', flash[:alert]
  end
end
