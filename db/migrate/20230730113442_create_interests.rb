# frozen_string_literal: true

class CreateInterests < ActiveRecord::Migration[7.0]
  def change
    create_table :interests do |t|
      t.string :email

      t.timestamps
    end

    add_index :interests, :email, unique: true
  end
end
