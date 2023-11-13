# frozen_string_literal: true

class ArtistsController < ApplicationController
  before_action :set_artist, only: %i[show edit update destroy]
  skip_before_action :authenticate, only: %i[index show]

  def index
    skip_authorization

    @artists = Artist.all
  end

  def show
    skip_authorization
  end

  def new
    @artist = Artist.new
    authorize @artist
  end

  def edit
    authorize @artist
  end

  def create
    @artist = Artist.new(artist_params)
    authorize @artist

    respond_to do |format|
      if @artist.save
        format.html { redirect_to artist_url(@artist), notice: 'Artist was successfully created.' }
        format.json { render :show, status: :created, location: @artist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @artist

    respond_to do |format|
      if @artist.update(artist_params)
        format.html { redirect_to artist_url(@artist), notice: 'Artist was successfully updated.' }
        format.json { render :show, status: :ok, location: @artist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
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
    params.require(:artist).permit(:name, :profile_picture, :location, :description, :listed)
  end
end
