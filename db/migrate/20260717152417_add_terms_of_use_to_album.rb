# frozen_string_literal: true

class AddTermsOfUseToAlbum < ActiveRecord::Migration[8.1]
  def change
    add_column :albums, :terms_of_use, :boolean, null: false, default: false

    Album.update_all terms_of_use: true # rubocop:disable Rails/SkipsModelValidations
  end
end
