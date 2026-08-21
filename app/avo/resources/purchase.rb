# frozen_string_literal: true

module Avo
  module Resources
    class Purchase < Avo::BaseResource
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
        field :price, as: :number
        field :contact_opt_in, as: :boolean
        field :stripe_session_id, as: :text
        field :completed, as: :boolean
        field :customer_email, as: :text
        field :amount_tax, as: :number
        field :user_id, as: :number
        field :sending_suppressed_at, as: :date_time
        field :payout_id, as: :number
        field :album, as: :belongs_to
        field :user, as: :belongs_to
        field :payout, as: :belongs_to
        field :purchase_downloads, as: :has_many
        field :artist, as: :belongs_to
        field :seller, as: :has_many, through: :artist
      end
    end
  end
end
