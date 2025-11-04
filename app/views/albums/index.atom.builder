# frozen_string_literal: true

atom_feed(root_url: albums_url, language: 'en-GB', schema_date: 2024) do |f|
  f.title 'Albums on jam.coop'
  f.updated @albums.first.first_published_on
  @albums.each do |album|
    id = "tag:#{request.host},2024:#{artist_album_path(album.artist, album)}"
    url = artist_album_url(album.artist, album)
    published = album.first_published_on
    f.entry(album, id:, url:, published:) do |e|
      e.title [album.title, album.artist.name].join(' by ')
      e.author { |a| a.name album.artist.name }
      html = []
      html << image_tag(cdn_url(album.cover.representation(resize_to_limit: [750, 750]))) if album.cover.attached?
      html << format_metadata(album.about)
      html << link_to('Listen on jam.coop', url)
      e.content safe_join(html), type: 'html'
    end
  end
end
