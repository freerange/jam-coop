# frozen_string_literal: true

class AddFirstPublishedAtToAlbums < ActiveRecord::Migration[7.1]
  def change
    add_column :albums, :first_published_on, :date

    reversible do |direction|
      direction.up do
        Album.published.includes(:tracks).find_each do |album|
          album.update!(
            first_published_on: [album.created_at, *album.tracks.map(&:created_at)].max
          )
        end
      end
    end
  end
end
