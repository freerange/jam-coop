# frozen_string_literal: true

class AddUniqAlbumIndexToReleases < ActiveRecord::Migration[8.1]
  def change
    remove_index :releases, :album_id
    add_index :releases, :album_id, unique: true
  end
end
