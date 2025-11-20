# frozen_string_literal: true

class CreateLabels < ActiveRecord::Migration[8.1]
  def change
    create_table :labels do |t|
      t.references :user, null: false, foreign_key: true
      t.string :slug
      t.string :location
      t.text :description
      t.string :name, null: false

      t.timestamps
    end

    add_index :labels, :slug, unique: true
  end
end
