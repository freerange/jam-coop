class AddLicenseToAlbum < ActiveRecord::Migration[7.1]
  def change
    add_reference :albums, :license, null: true, foreign_key: true
  end
end
