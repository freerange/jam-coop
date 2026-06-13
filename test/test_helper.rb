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

    def stub_retrieve_stripe_checkout_session(
      checkout_session_id, customer_email, amount_tax,
      payment_intent_id = 'pi_3TBDlLLj0fa0S8sd1X3zPYnl'
    )
      session = Stripe::Checkout::Session.construct_from(
        {
          id: checkout_session_id,
          customer_details: {
            email: customer_email
          },
          payment_intent: payment_intent_id,
          total_details: {
            amount_tax:
          }
        }
      )
      Stripe::Checkout::Session.stubs(:retrieve).with(checkout_session_id).returns(session)
      session
    end

    def stub_retrieve_stripe_payment_intent(
      payment_intent_id, amount = nil, application_fee_amount = nil, transfer_data = nil
    )
      payment_intent = Stripe::PaymentIntent.construct_from(
        {
          id: payment_intent_id,
          amount:,
          application_fee_amount:,
          transfer_data:
        }
      )
      Stripe::PaymentIntent.stubs(:retrieve).with(payment_intent_id).returns(payment_intent)
    end
  end
end

require 'mocha/minitest'
