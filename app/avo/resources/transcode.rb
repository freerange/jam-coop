# frozen_string_literal: true

module Avo
  module Resources
    class Transcode < Avo::BaseResource
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
        field :track_id, as: :number
        field :format, as: :select, enum: ::Transcode.formats
        field :file, as: :file
        field :track, as: :belongs_to
      end
    end
  end
end
