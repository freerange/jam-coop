# frozen_string_literal: true

class AddFollowings < ActiveRecord::Migration[8.1]
  def change
    create_table :followings do |t|
      t.belongs_to :artist, null: false
      t.belongs_to :user, null: false
      t.timestamps
    end
  end
end
