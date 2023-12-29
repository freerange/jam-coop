# frozen_string_literal: true

Stripe.api_key = Rails.configuration.stripe[:secret_key]
