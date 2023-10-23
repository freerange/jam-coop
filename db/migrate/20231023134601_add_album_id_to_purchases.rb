# frozen_string_literal: true

class AddAlbumIdToPurchases < ActiveRecord::Migration[7.0]
  def change
    add_reference :purchases, :album, foreign_key: true
  end
end
