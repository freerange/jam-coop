# frozen_string_literal: true

class AddSlugToArtists < ActiveRecord::Migration[7.0]
  def change
    add_column :artists, :slug, :string
    add_index :artists, :slug, unique: true
  end
end
