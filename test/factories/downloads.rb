# frozen_string_literal: true

FactoryBot.define do
  factory :download do
    format { :mp3v0 }
    album { nil }

    after(:build) do |download|
      download.file.attach(
        io: Rails.root.join('test/fixtures/files/album.zip').open,
        filename: 'album.zip',
        content_type: 'application/zip'
      )
    end
  end
end
