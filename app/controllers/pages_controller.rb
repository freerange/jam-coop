# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :authenticate
  before_action :skip_authorization

  def about; end
end
