# frozen_string_literal: true

class AddUniqueIndexOnFormatAndTrackToTranscode < ActiveRecord::Migration[7.0]
  def change
    add_index :transcodes, %i[format track_id], unique: true
  end
end
