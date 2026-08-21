# frozen_string_literal: true

module Avo
  module Resources
    class Label < Avo::BaseResource
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
        field :description, as: :textarea
        field :location, as: :text
        field :name, as: :text
        field :slug, as: :text
        field :user_id, as: :number
        field :logo, as: :file
        field :user, as: :belongs_to
        field :releases, as: :has_many
        field :albums, as: :has_many, through: :releases
      end
    end
  end
end
