# frozen_string_literal: true

class AddPublicationStatusToAlbums < ActiveRecord::Migration[7.1]
  def change
    add_column :albums, :publication_status, :integer, default: 0, null: false

    Album.find_each do |album|
      album.update(publication_status: 1) if album.published?
    end
  end
end
