# frozen_string_literal: true

class MakeAllPendingAlbumsUnpublished < ActiveRecord::Migration[7.2]
  class Album < ApplicationRecord
    enum :publication_status, { unpublished: 0, published: 1, pending: 2 }
  end

  def up
    Album.where(publication_status: :pending).find_each do |album|
      album.update(publication_status: :unpublished)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
