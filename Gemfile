# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: '.ruby-version'

gem 'active_storage_validations', '~> 3.0'
gem 'acts_as_list'
gem 'authentication-zero', '~> 4.0'
gem 'aws-sdk-s3'
gem 'bcrypt', '~> 3.1.22'
gem 'bootsnap', require: false
gem 'csv'
gem 'friendly_id', '~> 5.7.0'
gem 'image_processing'
gem 'importmap-rails'
gem 'jbuilder'
gem 'meta-tags', '~> 2.23'
gem 'mission_control-jobs'
gem 'pg', '~> 1.6'
gem 'pg_query'
gem 'postmark-rails'
gem 'propshaft'
gem 'prosopite'
gem 'puma', '~> 7.2'
gem 'pundit', '~> 2.5'
gem 'rack-maintenance'
gem 'rails', '~> 8.1'
gem 'rails_autolink', '~> 1.1'
gem 'rails_cloudflare_turnstile'
gem 'ransack'
gem 'redcarpet', '~> 3.6'
gem 'rollbar'
gem 'rss'
gem 'ruby-vips'
gem 'rubyzip', '~> 3.4'
gem 'solid_queue', '~> 1.6'
gem 'stimulus-rails'
gem 'stripe', '~> 19.5'
gem 'tailwindcss-rails', '~> 4.6'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[windows jruby]
gem 'view_component'
gem 'zaru', '~> 1.1'

group :development, :test do
  gem 'debug', platforms: %i[mri windows]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'htmlbeautifier'
  gem 'lookbook', '>= 2.3.13'
end

group :development do
  gem 'faker', '~> 3.8'
  gem 'hotwire-livereload'
  gem 'letter_opener'
  gem 'redis', '~> 5.0'
  gem 'rubocop-capybara', require: false
  gem 'rubocop-rails', require: false
end

group :test do
  gem 'capybara'
  gem 'capybara-playwright-driver'
  gem 'mocha'
  gem 'rubocop-factory_bot'
  gem 'webmock'
end
gem 'avo', '>= 4.0.0'
