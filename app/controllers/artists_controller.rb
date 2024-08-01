# frozen_string_literal: true

class ArtistsController < ApplicationController
  before_action :set_artist, only: %i[show edit update destroy]
  skip_before_action :authenticate, only: %i[index show]
  layout 'new', only: %i[index edit update new create]

  def index
    skip_authorization

    @artists = policy_scope(Artist)
  end

  def show
    skip_authorization

    @albums = policy_scope(@artist.albums)
  end

  def new
    @artist = Artist.new
    authorize @artist
  end

  def edit
    authorize @artist
  end

  def create
    @artist = Artist.new(artist_params.merge(user: Current.user))
    authorize @artist

    if @artist.save
      redirect_to artist_url(@artist), notice: 'Artist was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @artist

    if @artist.update(artist_params)
      redirect_to artist_url(@artist), notice: 'Artist was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @artist
    @artist.destroy

    respond_to do |format|
      format.html { redirect_to artists_url, notice: 'Artist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_artist
    @artist = Artist.friendly.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def artist_params
    params.require(:artist).permit(:name, :profile_picture, :location, :description)
  end
end
