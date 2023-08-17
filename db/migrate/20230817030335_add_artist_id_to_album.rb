# frozen_string_literal: true

class AddArtistIdToAlbum < ActiveRecord::Migration[7.0]
  def change
    add_reference :albums, :artist, null: false, default: 1, foreign_key: true
  end
end
