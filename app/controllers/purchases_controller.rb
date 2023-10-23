# frozen_string_literal: true

class PurchasesController < ApplicationController
  skip_before_action :authenticate
  before_action :set_album, except: :show

  def show
    @purchase = Purchase.find(params[:id])
  end

  def new; end

  def create
    purchase = Purchase.create(album: @album)

    resp = StripeService.new(purchase, cancel_url:).create_checkout_session

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

  def cancel_url
    artist_album_url(artist, @album)
  end
end
