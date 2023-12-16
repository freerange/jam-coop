# frozen_string_literal: true

class AdminConstraint
  class << self
    def matches?(request)
      cookies = ActionDispatch::Cookies::CookieJar.build(request, request.cookies)
      session = Session.find_by(id: cookies.signed[:session_token])
      session && session.user.present? && session.user.admin?
    end
  end
end
