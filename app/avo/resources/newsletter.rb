# frozen_string_literal: true

module Avo
  module Resources
    class Newsletter < Avo::BaseResource
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
        field :body, as: :textarea
        field :published_at, as: :date_time
      end
    end
  end
end
