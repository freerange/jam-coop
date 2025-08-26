# frozen_string_literal: true

FactoryBot.define do
  factory :purchase_download do
    format { :mp3v0 }
    purchase

    after(:build) do |purchase_download|
      purchase_download.file.attach(
        io: Rails.root.join('test/fixtures/files/album.zip').open,
        filename: 'album.zip',
        content_type: 'application/zip'
      )
    end
  end
end
