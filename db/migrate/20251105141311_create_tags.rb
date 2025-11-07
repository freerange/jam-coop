# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :musicbrainz_id
      t.string :disambiguation

      t.timestamps
    end

    add_index :tags, :name, unique: true
    add_index :tags, :musicbrainz_id, unique: true
  end
end
