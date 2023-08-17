# frozen_string_literal: true

class CreateArtists < ActiveRecord::Migration[7.0]
  def change
    create_table :artists do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
