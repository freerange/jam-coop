# frozen_string_literal: true

module Admin
  class ReleasesController < ApplicationController
    before_action :set_label
    before_action :set_release, only: %i[edit update destroy]

    def new
      @release = authorize @label.releases.new
    end

    def edit; end

    def create
      @release = authorize @label.releases.new(release_params)

      if @release.save
        redirect_to edit_admin_label_path(@label)
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @release.update(release_params)
        redirect_to edit_admin_label_path(@label)
      else
        render :new, status: :unprocessable_content
      end
    end

    def destroy
      @release.destroy
      redirect_to edit_admin_label_path(@label)
    end

    private

    def set_label
      @label = Current.user.labels.friendly.find(params[:label_id])
    end

    def set_release
      @release = authorize @label.releases.find(params[:id])
    end

    def release_params
      params.expect(release: %i[label album_id catalogue_number])
    end
  end
end
