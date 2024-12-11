# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

Rake::Task['test'].enhance(%i[rubocop htmlbeautifier])
Rake::Task['test'].enhance do
  Rake::Task['test:system'].invoke
end
