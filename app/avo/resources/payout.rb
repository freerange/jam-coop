# frozen_string_literal: true

module Avo
  module Resources
    class Payout < Avo::BaseResource
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
        field :payout_type, as: :text
        field :transaction_reference, as: :text
        field :destination_reference, as: :text
        field :amount_in_pence, as: :number
        field :platform_fee_in_pence, as: :number
        field :user, as: :belongs_to
        field :purchases, as: :has_many
      end
    end
  end
end
