# frozen_string_literal: true

class PurchaseDownload < ApplicationRecord
  belongs_to :purchase
  enum :format, { mp3v0: 0, mp3128k: 1, flac: 2 }
  has_one_attached :file
end
