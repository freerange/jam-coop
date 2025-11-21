# frozen_string_literal: true

class NewslettersController < ApplicationController
  skip_before_action :authenticate
  before_action :skip_authorization

  def index
    @newsletters = Newsletter.where.not(published_at: nil).order(published_at: :desc)
  end

  def show
    @newsletter = Newsletter.where.not(published_at: nil).find(params[:id])
  end
end
