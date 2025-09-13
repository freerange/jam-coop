# frozen_string_literal: true

Rails.logger.info 'Seeding development environment'

User.create!(email: 'admin@example.com', password: 'admin-jam-coop', verified: true, admin: true)
User.create!(email: 'fan@example.com', password: 'fan-jam-coop', verified: true)

6.times do |i|
  user = User.create(email: "artist-#{i}@example.com", password: "artist-#{i}-jam-coop", verified: true)
  artist = Artist.create!(
    name: Faker::Music.band,
    location: [Faker::Address.city, Faker::Address.country].join(', '),
    description: Faker::Lorem.paragraph,
    user:
  )
  artist.profile_picture.attach(
    io: Rails.root.join('test/fixtures/files/cover.png').open,
    filename: 'profile.jpg'
  )

  3.times do
    album = Album.build(
      title: Faker::Music.album,
      about: Faker::Lorem.paragraph,
      credits: Faker::Lorem.paragraph,
      license: License.find_by(code: 'all_rights_reserved'),
      released_on: Time.zone.today,
      artist:
    )
    album.cover.attach(
      io: Rails.root.join('test/fixtures/files/cover.png').open,
      filename: 'cover.jpg'
    )
    album.save!

    track1 = Track.build(title: 'One', position: 1, album:)
    track1.original.attach(io: Rails.root.join('test/fixtures/files/one.wav').open, filename: 'one.wav')
    track1.save!

    track2 = Track.build(title: 'Two', position: 2, album:)
    track2.original.attach(io: Rails.root.join('test/fixtures/files/two.wav').open, filename: 'two.wav')
    track2.save!

    track3 = Track.build(title: 'Three', position: 3, album:)
    track3.original.attach(io: Rails.root.join('test/fixtures/files/three.wav').open, filename: 'three.wav')
    track3.save!

    album.published!
  end
end
