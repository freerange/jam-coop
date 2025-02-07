# frozen_string_literal: true

class AddBelongsToLicenseRelationshipToAlbum < ActiveRecord::Migration[7.2]
  class License < ApplicationRecord; end

  def change
    add_reference :albums, :license, foreign_key: true

    default_license = License.find_or_create_by(code: 'all_rights_reserved', source: nil, label: 'All Rights Reserved')
    Album.find_each do |album|
      album.update(license_id: default_license.id)
    end
  end
end
