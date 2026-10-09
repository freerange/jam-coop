# frozen_string_literal: true

class CreateProfileLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :profile_links do |t|
      t.string :url, null: false
      t.integer :position
      t.references :artist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
