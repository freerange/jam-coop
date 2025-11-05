# frozen_string_literal: true

require 'net/https'
require 'json'
require 'uri'

module Musicbrainz
  class GenrePager
    BASE_URL = 'http://musicbrainz.org/ws/2/genre/all'
    LIMIT = 100

    def initialize(output_file = Rails.root.join('db/seeds/data/musicbrainz_genres.json'))
      @output_file = output_file
      @all_genres = []
    end

    def fetch_all_genres
      offset = 0
      total_count = nil

      loop do
        Rails.logger.debug { "Fetching genres with offset #{offset}..." }
        response = fetch_page(offset)

        total_count ||= response['genre-count']

        genres = response['genres'] || []
        @all_genres.concat(genres)

        break if offset + LIMIT >= total_count

        offset += LIMIT

        sleep(5)
      end

      save_to_disk
      Rails.logger.debug { "Saved #{@all_genres.length} genres to #{@output_file}" }
    end

    private

    def fetch_page(offset)
      uri = URI(BASE_URL)
      uri.query = URI.encode_www_form(
        limit: LIMIT,
        fmt: 'json',
        offset: offset
      )

      http = Net::HTTP.new(uri.host, uri.port)

      Rails.logger.debug { "Fetching #{uri}" }
      request = Net::HTTP::Get.new(uri)
      request['User-Agent'] = 'jam.coop (contact@jam.coop)'

      response = http.request(request)

      raise "API request failed: #{response.code} #{response.message}" unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body)
    rescue JSON::ParserError => e
      raise "Failed to parse JSON response: #{e.message}"
    end

    def save_to_disk
      output = JSON.pretty_generate({ 'total_count' => @all_genres.length,
                                      'genres' => @all_genres })
      File.write(@output_file, output)
    end
  end
end
