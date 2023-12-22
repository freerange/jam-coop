# frozen_string_literal: true

require 'zip'

class ZipDownloadJob < ApplicationJob
  queue_as :default

  def perform(album, format: :mp3v0)
    Dir.mktmpdir(nil, tmp_dir_location) do |dir|
      filenames = download_all_tracks(album, format, dir)

      zipfile_name = Zaru.sanitize!("#{album.artist.name} - #{album.title}.zip")

      Zip::File.open(File.join(dir, zipfile_name), create: true) do |zipfile|
        filenames.each do |filename|
          zipfile.add(filename, File.join(dir, filename))
        end
      end

      album.downloads.where(format:).destroy_all
      download = album.downloads.create(format:)
      download.file.attach(io: File.open(File.join(dir, zipfile_name)),
                           filename: zipfile_name,
                           content_type: 'application/zip')
    end
  end

  private

  def tmp_dir_location
    '/var/data' if Dir.exist?('/var/data')
  end

  def download_all_tracks(album, format, dir)
    filenames = []

    album.tracks.each do |track|
      track.transcodes.where(format:).find_each do |transcode|
        filename = track_filename(track, format)
        File.binwrite(File.join(dir, filename), transcode.file.download)
        filenames << filename
      end
    end

    filenames
  end

  def track_filename(track, format)
    Zaru.sanitize!("#{track.number} - #{track.title}.#{extension(format)}")
  end

  def extension(format)
    case format
    when :mp3v0, :mp3128k
      'mp3'
    when :flac
      'flac'
    else
      raise ArgumentError, "unsupported format: #{format}"
    end
  end
end
