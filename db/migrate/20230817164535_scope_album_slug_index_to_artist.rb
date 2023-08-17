# frozen_string_literal: true

class ScopeAlbumSlugIndexToArtist < ActiveRecord::Migration[7.0]
  def change
    remove_index :albums, :slug
    add_index :albums, %i[slug artist_id], unique: true
  end
end
