# frozen_string_literal: true

module Avo
  module Resources
    class Release < Avo::BaseResource
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
        field :label_id, as: :number
        field :catalogue_number, as: :text
        field :album, as: :belongs_to
        field :label, as: :belongs_to
      end
    end
  end
end
