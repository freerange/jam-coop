# frozen_string_literal: true

class AddPriceToAlbums < ActiveRecord::Migration[7.0]
  def change
    add_column :albums, :price, :decimal, precision: 8, scale: 2, default: 7.00
  end
end
