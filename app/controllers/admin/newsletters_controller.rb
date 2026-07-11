# frozen_string_literal: true

module Admin
  class NewslettersController < ApplicationController
    before_action :set_newsletter, only: %i[edit update]

    def index
      @newsletters = policy_scope(Newsletter)
      authorize @newsletters
    end

    def new
      @newsletter = authorize Newsletter.new
    end

    def edit; end

    def create
      @newsletter = authorize Newsletter.new(newsletter_params)

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
      @newsletter = authorize Newsletter.find(params[:id])
    end

    def newsletter_params
      params.expect(newsletter: %i[title body published_at])
    end
  end
end
