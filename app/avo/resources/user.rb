# frozen_string_literal: true

module Avo
  module Resources
    class User < Avo::BaseResource
      self.icon = 'tabler/outline/users'
      # self.avatar = {
      #   source: :avatar
      # }
      # self.includes = []
      # self.attachments = []

      self.search = {
        query: -> { query.ransack(email_cont: q).result(distinct: false) }
      }

      def fields
        field :id, as: :id
        # field :avatar, as: :avatar
        field :admin, as: :boolean
        field :email, as: :text
        field :labels_enabled, as: :boolean
        field :opt_in_to_newsletter, as: :boolean
        field :sending_suppressed_at, as: :date_time
        field :verified, as: :boolean
        field :stripe_connect_enabled, as: :boolean
        field :artists, as: :has_many
        field :albums, as: :has_many, through: :artists
        field :email_verification_tokens, as: :has_many
        field :password_reset_tokens, as: :has_many
        field :sessions, as: :has_many
        field :purchases, as: :has_many
        field :followings, as: :has_many
        field :followed_artists, as: :has_many, through: :followings
        field :labels, as: :has_many
        field :payouts, as: :has_many
        field :stripe_payouts, as: :has_many
        field :payout_detail, as: :has_one
        field :stripe_connect_account, as: :has_one
      end
    end
  end
end
