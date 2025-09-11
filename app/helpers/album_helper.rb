# frozen_string_literal: true

require 'rails_autolink/helpers'

module AlbumHelper
  def format_metadata(text)
    text_with_links = auto_link(text, html: { class: 'underline' }) do |t|
      t.gsub(%r{http.?://}, '')
    end
    simple_format(text_with_links, class: 'mb-2')
  end

  def seconds_to_formated_track_time(seconds)
    return '' unless seconds

    Time.at(seconds).utc.strftime('%M:%S')
  end

  def options_for_album_visibility
    option = Struct.new(:value, :text)

    Album.publication_statuses.map do |k, _|
      option.new(k, k.humanize)
    end
  end
end
