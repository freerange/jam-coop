# frozen_string_literal: true

class CreateLicenses < ActiveRecord::Migration[7.1]
  def change
    create_table :licenses do |t|
      t.string :code, null: false
      t.text :source, null: true
      t.text :label, null: false
      t.timestamps
    end
  end
end
