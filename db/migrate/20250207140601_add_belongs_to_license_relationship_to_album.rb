# frozen_string_literal: true

class AddBelongsToLicenseRelationshipToAlbum < ActiveRecord::Migration[7.2]
  class License < ApplicationRecord; end

  def change
    default_license = License.find_or_create_by(code: 'all_rights_reserved', source: nil, label: 'All Rights Reserved')

    add_reference :albums, :license, null: false, foreign_key: true, default: default_license.id
  end
end
