# frozen_string_literal: true

class StripeAccountsController < ApplicationController
  def create
    authorize StripeAccount

    account = Stripe::Account.create
    StripeAccount.create!(user: Current.user, stripe_identifier: account.id)

    redirect_to account_path
  end
end
