# frozen_string_literal: true

module RequestContext
  extend ActiveSupport::Concern

  included do
    before_action :load_request_context
  end

  def load_request_context
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
    Current.session = Session.find_by(id: cookies.signed[:session_token])
  end
end
