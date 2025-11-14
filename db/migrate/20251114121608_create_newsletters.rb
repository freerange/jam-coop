# frozen_string_literal: true

class CreateNewsletters < ActiveRecord::Migration[8.0]
  def change
    create_table :newsletters do |t|
      t.string :title, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
