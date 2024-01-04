# frozen_string_literal: true

class AssociateExistingPurchasesWithUsers < ActiveRecord::Migration[7.1]
  def change
    Purchase.find_each do |purchase|
      if (user = User.find_by(email: purchase.customer_email))
        purchase.update(user:)
      end
    end
  end
end
