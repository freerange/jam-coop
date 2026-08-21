# frozen_string_literal: true

module Avo
  module Resources
    class Tag < Avo::BaseResource
      self.icon = 'tabler/outline/tag'
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
        field :name, as: :text
        field :musicbrainz_id, as: :text
        field :disambiguation, as: :text
        field :slug, as: :text
        field :albums, as: :has_many, through: :taggings
      end
    end
  end
end
