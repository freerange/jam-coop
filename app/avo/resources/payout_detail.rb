# frozen_string_literal: true

module Avo
  module Resources
    class PayoutDetail < Avo::BaseResource
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
        field :country, as: :country
        field :name, as: :text
        field :user_id, as: :number
        field :user, as: :belongs_to
      end
    end
  end
end
