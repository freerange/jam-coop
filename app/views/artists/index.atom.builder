# frozen_string_literal: true

artists = @artists.listed.sort_by(&:first_listed_on).reverse.take(20)

atom_feed(root_url: artists_url, language: 'en-GB', schema_date: 2024) do |f|
  f.title 'Artists on jam.coop'
  f.updated artists.first.updated_at
  artists.each do |artist|
    id = "tag:#{request.host},2024:#{artist_path(artist)}"
    published = artist.first_listed_on
    f.entry(artist, id:, published:) do |e|
      e.title artist.name
      e.author { |a| a.name 'jam.coop' }
      html = []
      if artist.profile_picture.attached?
        html << image_tag(cdn_url(artist.profile_picture.representation(resize_to_limit: [500, 500])))
      end
      html << format_metadata(artist.description)
      html << link_to("View #{artist.name} on jam.coop", artist_url(artist))
      e.content safe_join(html), type: 'html'
    end
  end
end
