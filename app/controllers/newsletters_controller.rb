# frozen_string_literal: true

class NewslettersController < ApplicationController
  skip_before_action :authenticate
  before_action :skip_authorization

  def index
    @newsletters = Newsletter.published.order(published_at: :desc)
  end

  def show
    @newsletter = Newsletter.published.find(params[:id])
  end
end
