# frozen_string_literal: true

class TrackPolicy < ApplicationPolicy
  delegate :new?, :create?, :edit?, :update?, :destroy?, to: :album_policy

  alias multiple? new?
  alias create_multiple? create?
  alias move_lower? update?
  alias move_higher? update?

  def album_policy
    @album_policy ||= AlbumPolicy.new(user, record.album)
  end
end
