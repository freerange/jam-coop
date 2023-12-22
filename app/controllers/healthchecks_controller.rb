# frozen_string_literal: true

class HealthchecksController < Rails::HealthController
  def show
    ActiveRecord::Base.connection.execute('select 1')
    super
  end
end
