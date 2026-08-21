# frozen_string_literal: true

module Avo
  module Resources
    class Following < Avo::BaseResource
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
        field :artist_id, as: :number
        field :user_id, as: :number
        field :artist, as: :belongs_to
        field :user, as: :belongs_to
      end
    end
  end
end
