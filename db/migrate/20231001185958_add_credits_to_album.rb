# frozen_string_literal: true

class AddCreditsToAlbum < ActiveRecord::Migration[7.0]
  def change
    add_column :albums, :credits, :text
  end
end
