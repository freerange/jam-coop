# frozen_string_literal: true

module Avo
  module Resources
    class PurchaseDownload < Avo::BaseResource
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
        field :format, as: :select, enum: ::PurchaseDownload.formats
        field :purchase_id, as: :text
        field :file, as: :file
        field :purchase, as: :belongs_to
      end
    end
  end
end
