# frozen_string_literal: true

module Admin
  class LabelsController < ApplicationController
    before_action :build_label, only: %i[new create]
    before_action :set_label, only: %i[edit update]

    def new; end
    def edit; end

    def create
      if @label.save
        redirect_to account_path, notice: 'Label was successfully created.'
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @label.update(label_params)
        redirect_to account_path, notice: 'Label was successfully updated.'
      else
        render :edit, status: :unprocessable_content
      end
    end

    private

    def build_label
      @label = authorize Current.user.labels.new(params[:label].present? ? label_params : {})
    end

    def set_label
      @label = authorize Current.user.labels.friendly.includes(
        releases: {
          album: [:artist, { cover_attachment: :blob }]
        }
      ).find(params.expect(:id))
    end

    def label_params
      params
        .expect(
          label: %i[
            name
            location
            description
            logo
          ]
        )
    end
  end
end
