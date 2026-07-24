# frozen_string_literal: true

class NewslettersController < ApplicationController
  skip_before_action :authenticate

  def index
    @newsletters = policy_scope(Newsletter).order(published_at: :desc)
  end

  def show
    @newsletter = authorize Newsletter.find(params[:id])
  end
end
