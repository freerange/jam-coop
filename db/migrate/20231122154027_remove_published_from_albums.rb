# frozen_string_literal: true

class RemovePublishedFromAlbums < ActiveRecord::Migration[7.1]
  def change
    remove_column :albums, :published, :boolean
  end
end
