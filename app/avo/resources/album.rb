# frozen_string_literal: true

module Avo
  module Resources
    class Album < Avo::BaseResource
      # self.icon = "tabler/outline/users"
      # self.avatar = {
      #   source: :avatar
      # }
      # self.includes = []
      # self.attachments = []
      # self.search = {
      #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
      # }

      def fields
        field :id, as: :id
        # field :avatar, as: :avatar
        field :title, as: :text
        field :slug, as: :text
        field :artist_id, as: :number
        field :about, as: :textarea
        field :credits, as: :textarea
        field :price, as: :number
        field :released_on, as: :date
        field :publication_status, as: :select, enum: ::Album.publication_statuses
        field :first_published_on, as: :date
        field :license_id, as: :number
        field :terms_of_use, as: :boolean
        field :ai_policy, as: :boolean
        field :cover, as: :file
        field :artist, as: :belongs_to
        field :tracks, as: :has_many
        field :purchases, as: :has_many
        field :license, as: :belongs_to
        field :release, as: :has_one
        field :label, as: :has_one
      end
    end
  end
end
