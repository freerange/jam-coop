# frozen_string_literal: true

class AddTranscodes < ActiveRecord::Migration[7.0]
  def change
    create_table :transcodes do |t|
      t.belongs_to :track
      t.integer :format, default: 0, null: false
      t.timestamps
    end
  end
end
