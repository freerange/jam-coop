# frozen_string_literal: true

class AddFeaturedToLabels < ActiveRecord::Migration[8.1]
  def change
    add_column :labels, :featured, :boolean, default: false, null: false
  end
end
