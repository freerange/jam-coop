# frozen_string_literal: true

module Avo
  module Resources
    class Track < Avo::BaseResource
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
        field :position, as: :number
        field :album_id, as: :number
        field :original, as: :file
        field :album, as: :belongs_to
        field :transcodes, as: :has_many
      end
    end
  end
end
