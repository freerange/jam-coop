# frozen_string_literal: true

class PurchasesController < ApplicationController
  skip_before_action :authenticate
  before_action :set_album, except: :show

  def show
    @purchase = Purchase.find(params[:id])
  end

  def new
    @purchase = Purchase.new(album: @album)
  end

  def create
    purchase = Purchase.new(album: @album)

    if purchase.save
      resp = StripeService.new(purchase).create_checkout_session

      if resp.success?
        redirect_to resp.url, allow_other_host: true
      else
        flash[:alert] = resp.error
        redirect_to new_artist_album_purchase_path(artist, @album)
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_album
    @album = artist.albums.friendly.find(params[:album_id])
  end

  def artist
    Artist.friendly.find(params[:artist_id])
  end
end
