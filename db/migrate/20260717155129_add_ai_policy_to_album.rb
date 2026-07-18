# frozen_string_literal: true

class AddAiPolicyToAlbum < ActiveRecord::Migration[8.1]
  def change
    add_column :albums, :ai_policy, :boolean, null: false, default: false
  end
end
