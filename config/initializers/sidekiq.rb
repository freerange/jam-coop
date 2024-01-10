# frozen_string_literal: true

Sidekiq.default_job_options = { retry: 3 }
