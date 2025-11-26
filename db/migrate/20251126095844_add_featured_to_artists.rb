# frozen_string_literal: true

class AddFeaturedToArtists < ActiveRecord::Migration[8.1]
  def change
    add_column :artists, :featured, :boolean, default: false, null: false
  end
end
