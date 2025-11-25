# frozen_string_literal: true

module Admin
  class ReleasesController < ApplicationController
    before_action :set_label

    def new
      authorize @label
    end

    private

    def set_label
      @label = Current.user.labels.friendly.find(params[:label_id])
    end

    def release_params
      params.require(:release).permit(:label)
    end
  end
end
