# frozen_string_literal: true

module Avo
  module Resources
    class Artist < Avo::BaseResource
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
        field :name, as: :text
        field :slug, as: :text
        field :location, as: :text
        field :description, as: :textarea
        field :user_id, as: :number
        field :featured, as: :boolean
        field :profile_picture, as: :file
        field :user, as: :belongs_to
        field :albums, as: :has_many
        field :followings, as: :has_many
        field :followers, as: :has_many, through: :followings
      end
    end
  end
end
