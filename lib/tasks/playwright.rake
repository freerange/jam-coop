# frozen_string_literal: true

namespace :test do
  desc 'Run Playwright tests'
  task playwright: :environment do
    sh 'bin/rails test test/playwright'
  end
end
