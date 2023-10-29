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
end
