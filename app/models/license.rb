class License < ApplicationRecord
  validates :code, presence: true
end
