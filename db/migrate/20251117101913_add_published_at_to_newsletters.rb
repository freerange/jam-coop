# frozen_string_literal: true

class AddPublishedAtToNewsletters < ActiveRecord::Migration[8.1]
  def change
    add_column :newsletters, :published_at, :datetime
  end
end
