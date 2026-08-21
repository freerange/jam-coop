# frozen_string_literal: true

module Avo
  module Resources
    class License < Avo::BaseResource
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
        field :code, as: :text
        field :source, as: :textarea
        field :label, as: :textarea
      end
    end
  end
end
