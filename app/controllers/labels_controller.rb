# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :set_label, only: %i[show]
  skip_before_action :authenticate, only: %i[index show]

  def index
    skip_authorization

    @labels = policy_scope(Label).includes(:releases).includes(logo_attachment: :blob).order(created_at: :desc)
  end

  def show
    skip_authorization

    @albums = policy_scope(@label.albums.includes(:artist)).includes(cover_attachment: :blob)
  end

  private

  def set_label
    @label = Label.find(params.expect(:id))
  end
end
