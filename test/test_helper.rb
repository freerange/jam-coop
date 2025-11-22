# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'

module ActiveSupport
  class TestCase
    parallelize(workers: 1)

    include FactoryBot::Syntax::Methods

    WebMock.disable_net_connect!(allow_localhost: true)

    # Run tests in parallel with specified workers
    # parallelize(workers: :number_of_processors)

    def log_in_as(user)
      post(log_in_path, params: { email: user.email, password: 'Secret1*3*5*' })
      user
    end

    private

    def stub_retrieve_stripe_checkout_session(checkout_session_id, customer_email, amount_tax)
      session = Stripe::Checkout::Session.construct_from(
        {
          id: checkout_session_id,
          customer_details: {
            email: customer_email
          },
          total_details: {
            amount_tax:
          }
        }
      )
      Stripe::Checkout::Session.stubs(:retrieve).with(checkout_session_id).returns(session)
    end
  end
end

require 'mocha/minitest'
