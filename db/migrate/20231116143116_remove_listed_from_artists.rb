# frozen_string_literal: true

class RemoveListedFromArtists < ActiveRecord::Migration[7.1]
  def change
    remove_column :artists, :listed, :boolean
  end
end
