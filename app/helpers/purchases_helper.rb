# frozen_string_literal: true

module PurchasesHelper
  def link_to_payment_intent(purchase, html_options = nil)
    id = purchase.payment_intent_id
    return if id.blank?

    dashboard_origin = 'https://dashboard.stripe.com'
    env_path = Rails.env.production? ? nil : 'test'
    payment_path = "payments/#{id}"
    url = [dashboard_origin, env_path, payment_path].compact.join('/')
    link_to id, url, html_options
  end
end
