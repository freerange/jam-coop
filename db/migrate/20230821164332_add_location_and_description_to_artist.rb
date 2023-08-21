# frozen_string_literal: true

class AddLocationAndDescriptionToArtist < ActiveRecord::Migration[7.0]
  def change
    change_table :artists, bulk: true do |t|
      t.string :location
      t.string :description
    end
  end
end
