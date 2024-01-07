# frozen_string_literal: true

artists = @artists.sort_by(&:first_listed_on).reverse

atom_feed(root_url: artists_url, language: 'en-GB', schema_date: 2024) do |f|
  f.title 'Artists on jam.coop'
  f.updated artists.first.updated_at
  artists.each do |artist|
    id = "tag:#{request.host},2024:#{artist_path(artist)}"
    published = artist.first_listed_on
    f.entry(artist, id:, published:) do |e|
      e.title artist.name
      e.author { |a| a.name 'jam.coop' }
      e.content artist.description, type: 'html'
    end
  end
end
