# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'active_storage_validations', '~> 1.1'
gem 'acts_as_list'
gem 'authentication-zero', '~> 3.0'
gem 'aws-sdk-s3'
gem 'bcrypt', '~> 3.1.20'
gem 'bootsnap', require: false
gem 'friendly_id', '~> 5.5.0'
gem 'image_processing'
gem 'importmap-rails'
gem 'jbuilder'
gem 'meta-tags', '~> 2.19'
gem 'pg', '~> 1.5'
gem 'postmark-rails'
gem 'puma', '~> 6.4'
gem 'pundit', '~> 2.3'
gem 'rack-maintenance'
gem 'rails', '~> 7.2'
gem 'rails_autolink', '~> 1.1'
gem 'rails_cloudflare_turnstile'
gem 'redcarpet', '~> 3.6'
gem 'redis', '~> 5.0'
gem 'rollbar'
gem 'rss'
gem 'rubyzip', '~> 2.3'
gem 'sidekiq'
gem 'solid_queue', '~> 1.1'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'stripe', '~> 13.2'
gem 'tailwindcss-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'view_component'
gem 'zaru', '~> 1.0'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'htmlbeautifier'
end

group :development do
  gem 'faker', '~> 3.3'
  gem 'hotwire-livereload'
  gem 'letter_opener'
  gem 'rubocop-capybara', require: false
  gem 'rubocop-rails', require: false
end

group :test do
  gem 'capybara'
  gem 'cuprite'
  gem 'mocha', '~> 2.1'
  gem 'rubocop-factory_bot'
  gem 'selenium-webdriver'
  gem 'webmock'
end
