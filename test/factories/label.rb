# frozen_string_literal: true

FactoryBot.define do
  factory :label do
    user
    name { 'Jam Records' }

    after(:build) do |label|
      label.logo.attach(
        io: Rails.root.join('test/fixtures/files/cover.png').open,
        filename: 'cover.png',
        content_type: 'image/png'
      )
    end
  end
end
