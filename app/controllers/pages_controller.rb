# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :authenticate

  def about; end
end
