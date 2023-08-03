# frozen_string_literal: true

class AddEmailConfirmedColumnToInterests < ActiveRecord::Migration[7.0]
  def change
    change_table :interests, bulk: true do |t|
      t.boolean :email_confirmed, default: false, null: false
      t.string :confirm_token
    end
  end
end
