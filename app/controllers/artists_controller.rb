# frozen_string_literal: true

class ArtistsController < ApplicationController
  before_action :set_artist, only: %i[show edit update destroy]
  skip_before_action :authenticate, only: %i[index show]

  def index
    skip_authorization

    @artists = policy_scope(Artist).includes(:albums, profile_picture_attachment: :blob)
  end

  def show
    skip_authorization

    @albums = policy_scope(@artist.albums).includes(cover_attachment: :blob)
  end

  def new
    @artist = Artist.new
    @user = Current.user

    authorize @artist
  end

  def edit
    authorize @artist
  end

  def create
    @artist = Artist.new(artist_params.merge(user: Current.user))
    authorize @artist

    respond_to do |format|
      if @artist.save
        format.html do
          redirect_to(
            edit_artist_path(@artist),
            notice: 'Artist was successfully created. You can now add albums below.'
          )
        end
        format.json { render :show, status: :created, location: @artist }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @artist.errors, status: :unprocessable_content }
      end
    end
  end

  def update
    authorize @artist

    respond_to do |format|
      if @artist.update(artist_params)
        format.html { redirect_to artist_path(@artist), notice: 'Artist was successfully updated.' }
        format.json { render :show, status: :ok, location: @artist }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @artist.errors, status: :unprocessable_content }
      end
    end
  end

  def destroy
    authorize @artist
    @artist.destroy

    respond_to do |format|
      format.html { redirect_to artists_path, notice: 'Artist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_artist
    @artist = Artist.friendly.find(params[:id])
  end

  def artist_params
    params.require(:artist).permit(:name, :profile_picture, :location, :description)
  end
end
