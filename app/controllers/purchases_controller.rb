# frozen_string_literal: true

class PurchasesController < ApplicationController
  skip_before_action :authenticate
  before_action :set_album

  def new; end

  def create
    resp = StripeService.create_checkout_session(Current.user, @album, success_url:, cancel_url:)

    if resp.success?
      redirect_to resp.url, allow_other_host: true
    else
      flash[:alert] = resp.error
      redirect_to new_artist_album_purchase_path(artist, @album)
    end
  end

  private

  def set_album
    @album = artist.albums.friendly.find(params[:album_id])
  end

  def artist
    Artist.friendly.find(params[:artist_id])
  end

  def success_url
    artist_album_url(artist, @album)
  end

  def cancel_url
    artist_album_url(artist, @album)
  end
end
