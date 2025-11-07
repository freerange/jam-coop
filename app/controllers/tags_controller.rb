# frozen_string_literal: true

class TagsController < ApplicationController
  skip_before_action :authenticate, only: %i[show]

  def show
    skip_authorization

    @tag = Tag.find(params[:id])
    @albums = @tag.albums
  end
end
