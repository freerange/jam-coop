# frozen_string_literal: true

desc 'Run Rubocop'
task rubocop: :environment do
  sh 'bundle exec rubocop'
end
