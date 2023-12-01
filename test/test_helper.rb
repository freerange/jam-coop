# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods

    # Run tests in parallel with specified workers
    # parallelize(workers: :number_of_processors)

    def log_in_as(user)
      post(log_in_url, params: { email: user.email, password: 'Secret1*3*5*' })
      user
    end
  end
end

require 'mocha/minitest'
