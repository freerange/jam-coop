class License < ApplicationRecord
  validates :text, presence: true
  validates :code, presence: true
end
