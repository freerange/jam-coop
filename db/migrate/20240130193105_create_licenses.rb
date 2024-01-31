class CreateLicenses < ActiveRecord::Migration[7.1]
  def change
    create_table :licenses do |t|
      t.text :text, null: false
      t.string :code, null: false
      t.text :url, null: true
      t.timestamps
    end
  end
end
