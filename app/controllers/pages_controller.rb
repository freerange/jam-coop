# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :authenticate
  before_action :skip_authorization

  def home
    @recently_released_albums = Album.published.recently_released.limit(4)
    @best_selling_albums = Album.best_selling.limit(4)
  end

  def about; end
  def terms; end
  def blog; end
end
