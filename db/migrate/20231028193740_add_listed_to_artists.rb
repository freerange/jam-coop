# frozen_string_literal: true

class AddListedToArtists < ActiveRecord::Migration[7.1]
  def change
    add_column :artists, :listed, :boolean, default: true, null: false
  end
end
