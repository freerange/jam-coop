# frozen_string_literal: true

albums = @albums.in_release_order

atom_feed(language: 'en-GB', schema_date: 2024) do |f|
  f.title "#{@artist.name} albums on jam.coop"
  f.updated albums.first&.released_on || @artist.updated_at
  f.author { |a| a.name @artist.name }
  albums.each do |album|
    id = "tag:#{request.host},2024:#{artist_album_path(@artist, album)}"
    url = artist_album_url(@artist, album)
    published = album.released_on
    f.entry(album, id:, url:, published:) do |e|
      e.title album.title
      e.author { |a| a.name @artist.name }
      html = []
      html << image_tag(cdn_url(album.cover.representation(resize_to_limit: [750, 750]))) if album.cover.attached?
      html << format_metadata(album.about)
      html << link_to('Listen on jam.coop', url)
      e.content safe_join(html), type: 'html'
    end
  end
end
