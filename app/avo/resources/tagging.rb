# frozen_string_literal: true

module Avo
  module Resources
    class Tagging < Avo::BaseResource
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
        field :album_id, as: :number
        field :tag_id, as: :number
        field :album, as: :belongs_to
        field :tag, as: :belongs_to
      end
    end
  end
end
