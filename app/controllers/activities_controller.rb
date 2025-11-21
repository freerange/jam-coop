# frozen_string_literal: true

class ActivitiesController < ApplicationController
  def show
    authorize :activity_feed

    @albums = Album.includes(:artist, { cover_attachment: :blob }).published.followed_by(Current.user).in_release_order
  end
end
