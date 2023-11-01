# frozen_string_literal: true

class AddReleaseDateToAlbums < ActiveRecord::Migration[7.1]
  def change
    add_column :albums, :released_at, :date
  end
end
