# frozen_string_literal: true

class FollowingsController < ApplicationController
  def create
    authorize Following

    artist = Artist.friendly.find(params[:artist_id])
    Current.user.follow(artist)

    redirect_to artist_path(artist), notice: "You are now following #{artist.name}"
  end
end
