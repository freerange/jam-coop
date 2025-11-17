# frozen_string_literal: true

module Admin
  class NewslettersController < ApplicationController
    before_action :set_newsletter, only: %i[edit update]

    def index
      @newsletters = policy_scope(Newsletter)
      authorize @newsletters
    end

    def new
      @newsletter = Newsletter.new
      authorize @newsletter
    end

    def edit; end

    def create
      @newsletter = Newsletter.new(newsletter_params)
      authorize @newsletter

      if @newsletter.save
        redirect_to edit_admin_newsletter_path(@newsletter), notice: 'Newsletter was successfully created.'
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @newsletter.update(newsletter_params)
        redirect_to edit_admin_newsletter_path(@newsletter), notice: 'Newsletter was successfully updated.'
      else
        render :edit, status: :unprocessable_content
      end
    end

    private

    def set_newsletter
      @newsletter = Newsletter.find(params[:id])
      authorize @newsletter
    end

    def newsletter_params
      params.require(:newsletter).permit(:title, :body, :published_at)
    end
  end
end
