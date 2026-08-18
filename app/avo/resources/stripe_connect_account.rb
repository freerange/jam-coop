# frozen_string_literal: true

module Avo
  module Resources
    class StripeConnectAccount < Avo::BaseResource
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
        field :stripe_identifier, as: :text
        field :details_submitted, as: :boolean
        field :charges_enabled, as: :boolean
        field :payouts_enabled, as: :boolean
        field :country_code, as: :text
        field :user, as: :belongs_to
      end
    end
  end
end
