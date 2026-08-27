# frozen_string_literal: true

namespace :factory_bot do
  desc 'Verify that all FactoryBot factories are valid'
  task lint: :environment do
    ActiveRecord::Base.connection.transaction do
      FactoryBot.lint
      raise ActiveRecord::Rollback
    end
  end
end
