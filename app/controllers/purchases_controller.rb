# frozen_string_literal: true

class PurchasesController < ApplicationController
  skip_before_action :authenticate
  before_action :set_album, except: :show
  before_action :skip_authorization

  def show
    @purchase = Purchase.includes(purchase_downloads: { file_attachment: :blob }).find(params[:id])
  end

  def new
    @purchase = Purchase.new(album: @album)
  end

  def create
    @purchase = Purchase.new(
      album: @album, price: purchase_params[:price],
      contact_opt_in: purchase_params[:contact_opt_in],
      user: Current.user
    )

    if @purchase.save
      resp = StripeService.new(@purchase).create_checkout_session

      if resp.success?
        @purchase.update!(stripe_session_id: resp.id)
        redirect_to resp.url, allow_other_host: true
      else
        flash[:alert] = resp.error
        redirect_to new_artist_album_purchase_path(artist, @album)
      end
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def set_album
    @album = artist.albums.friendly.find(params[:album_id])
  end

  def artist
    Artist.friendly.find(params[:artist_id])
  end

  def purchase_params
    params.expect(purchase: %i[price contact_opt_in])
  end
end
