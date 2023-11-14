# frozen_string_literal: true

require 'test_helper'
require 'zip'

class ZipDownloadJobTest < ActiveJob::TestCase
  test 'creates a zip file' do
    album = create(:album)
    track1 = create(:track, album:, title: 'First Track', position: 1)
    track2 = create(:track, album:, title: 'Second Track', position: 2)
    create(:transcode, track: track1, format: :mp3v0)
    create(:transcode, track: track2, format: :mp3v0)

    ZipDownloadJob.perform_now(album)

    assert_equal 1, album.downloads.count

    entries = []
    album.downloads.last.file.open do |zip_file|
      Zip::File.open(zip_file) do |zip|
        zip.each do |entry|
          entries << entry.name
        end
      end
    end

    assert entries.include? '01 - First Track.mp3'
    assert entries.include? '02 - Second Track.mp3'
  end

  test 'replaces existing zip file' do
    album = create(:album)
    track = create(:track, album:)
    create(:transcode, track:, format: :mp3v0)
    create(:download, album:, format: :mp3v0)

    assert_equal 1, album.downloads.count
    ZipDownloadJob.perform_now(album)
    assert_equal 1, album.reload.downloads.count
  end

  test 'creates a zip file when the album title contains a /' do
    album = create(:album, title: 'Slash / Slash')
    track = create(:track, album:, title: 'First / Track', position: 1)
    create(:transcode, track:, format: :mp3v0)

    ZipDownloadJob.perform_now(album)

    assert_equal 1, album.downloads.count

    entries = []
    album.downloads.last.file.open do |zip_file|
      Zip::File.open(zip_file) do |zip|
        zip.each do |entry|
          entries << entry.name
        end
      end
    end

    assert entries.include? '01 - First Track.mp3'
  end
end
