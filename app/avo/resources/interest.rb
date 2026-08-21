# frozen_string_literal: true

module Avo
  module Resources
    class Interest < Avo::BaseResource
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
        field :email, as: :text
        field :email_confirmed, as: :boolean
        field :confirm_token, as: :text
        field :sending_suppressed_at, as: :date_time
      end
    end
  end
end
