# frozen_string_literal: true

module Avo
  module Resources
    class Session < Avo::BaseResource
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
        field :user_id, as: :number
        field :user_agent, as: :text
        field :ip_address, as: :text
        field :user, as: :belongs_to
      end
    end
  end
end
