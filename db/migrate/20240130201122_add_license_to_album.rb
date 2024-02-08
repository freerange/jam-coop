class AddLicenseToAlbum < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_reference :albums, :license, null: true, index: {algorithm: :concurrently}
  end
end
