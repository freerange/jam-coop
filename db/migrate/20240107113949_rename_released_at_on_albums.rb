# frozen_string_literal: true

class RenameReleasedAtOnAlbums < ActiveRecord::Migration[7.1]
  def change
    rename_column :albums, :released_at, :released_on
  end
end
