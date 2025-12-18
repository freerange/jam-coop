# frozen_string_literal: true

class AddCatalogueNumberToReleases < ActiveRecord::Migration[8.1]
  def change
    add_column :releases, :catalogue_number, :string, limit: 12
  end
end
