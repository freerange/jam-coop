# frozen_string_literal: true

class NewslettersController < ApplicationController
  skip_before_action :authenticate
  before_action :skip_authorization

  def index
    @newsletters = Newsletter.order(published_at: :desc)
  end
end
