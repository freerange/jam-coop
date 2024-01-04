# frozen_string_literal: true

class CollectionsController < ApplicationController
  def show
    authorize User
  end
end
