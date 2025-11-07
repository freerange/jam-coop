# frozen_string_literal: true

desc 'Import genre tags into database'
task import_genre_tags: :environment do
  musicbrainz_genres = JSON.load_file(Rails.root.join('db/seeds/data/musicbrainz_genres.json'))

  musicbrainz_genres['genres'].each do |genre|
    Tag.find_or_create_by!(name: genre['name'], musicbrainz_id: genre['id'], disambiguation: genre['disambiguation'])
  end
end
