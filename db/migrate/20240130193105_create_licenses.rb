class CreateLicenses < ActiveRecord::Migration[7.1]
  def change
    create_table :licenses do |t|
      t.string :code, null: false
      t.text :source, null: true
      t.text :display_text, null: false
      t.timestamps
    end
  end
end
