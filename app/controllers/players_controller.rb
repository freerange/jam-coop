# frozen_string_literal: true

class PlayersController < ApplicationController
  layout 'player'

  skip_before_action :authenticate
  after_action :allow_iframe

  content_security_policy do |policy|
    policy.frame_ancestors :self, 'https:'
  end

  helper_method :album, :artist

  def show; end

  private

  def album
    @album ||= authorize(
      artist.albums.includes(:tracks).merge(Track.with_attachments).find(params.expect(:album_id))
    )
  end

  def artist
    @artist ||= Artist.find(params.expect(:artist_id))
  end

  def allow_iframe
    response.headers.delete('X-Frame-Options')
  end
end
