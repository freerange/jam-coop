# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :authenticate
  before_action :skip_authorization

  def home
    @featured_artist = Artist.of_the_day
    @best_selling_albums = Album.best_selling.includes(:artist, { cover_attachment: :blob }).limit(4)
  end

  def about; end
  def terms; end
end
