# frozen_string_literal: true

class CreateTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :tracks do |t|
      t.string :title
      t.integer :position
      t.references :album

      t.timestamps
    end
  end
end
