# frozen_string_literal: true

FactoryBot.define do
  factory :transcode do
    track
    format { :mp3128k }

    after(:build) do |transcode|
      transcode.file.attach(
        io: Rails.root.join('test/fixtures/files/track.mp3').open,
        filename: 'track.mp3',
        content_type: 'audio/mpeg'
      )
    end
  end
end
