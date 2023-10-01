# frozen_string_literal: true

class AddAboutToAlbum < ActiveRecord::Migration[7.0]
  def change
    add_column :albums, :about, :text
  end
end
