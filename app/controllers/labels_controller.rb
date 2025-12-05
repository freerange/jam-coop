# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :set_label, only: %i[show]
  skip_before_action :authenticate, only: %i[show]

  def show
    skip_authorization

    @albums = @label.albums.includes(cover_attachment: :blob)
  end

  private

  def set_label
    @label = Label.friendly.find(params[:id])
  end
end
