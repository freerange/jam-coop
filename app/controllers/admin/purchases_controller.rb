# frozen_string_literal: true

module Admin
  class PurchasesController < AdminController
    def index
      @purchases = policy_scope(Purchase).includes(album: :artist).completed.order(:created_at)
    end
  end
end
