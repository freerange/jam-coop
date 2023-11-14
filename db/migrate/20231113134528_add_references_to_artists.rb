# frozen_string_literal: true

class AddReferencesToArtists < ActiveRecord::Migration[7.1]
  def change
    add_reference :artists, :user, foreign_key: true
  end
end
