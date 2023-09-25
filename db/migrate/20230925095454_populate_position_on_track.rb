# frozen_string_literal: true

class PopulatePositionOnTrack < ActiveRecord::Migration[7.0]
  def change
    Album.all.each do |album|
      album.tracks.order(:updated_at).each_with_index do |track, index|
        track.update_column :position, index + 1 # rubocop:disable Rails/SkipsModelValidations
      end
    end
  end
end
