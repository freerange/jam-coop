# frozen_string_literal: true

module Admin
  class ReleasesController < ApplicationController
    before_action :set_label
    before_action :build_release
    before_action :authorize_label

    def new; end

    def create
      if @release.save
        redirect_to edit_admin_label_path(@label)
      else
        render :new, status: :unprocessable_content
      end
    end

    private

    def set_label
      @label = Current.user.labels.friendly.find(params[:label_id])
    end

    def build_release
      @release = @label.releases.new(params[:release].present? ? release_params : {})
    end

    def release_params
      params.require(:release).permit(:label, :album_id)
    end

    def authorize_label
      authorize @label
    end
  end
end
