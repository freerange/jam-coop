# frozen_string_literal: true

class DocsController < ApplicationController
  skip_before_action :authenticate
  before_action :skip_authorization

  def about; end
  def terms; end
  def ai_policy; end
  def alternatives; end
  def privacy_policy; end
end
