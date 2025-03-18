# frozen_string_literal: true

class StripeConnectAccountsController < ApplicationController
  before_action :set_user
  before_action :set_stripe_connect_account, except: %i[create]

  def create
    authorize StripeConnectAccount

    account = Stripe::Account.create(create_params)
    StripeConnectAccount.create!(user: @user, stripe_identifier: account.id)

    redirect_to link_stripe_connect_account_path(account.id)
  end

  def link
    authorize @stripe_connect_account

    account_link = Stripe::AccountLink.create(link_params)
    redirect_to account_link.url, allow_other_host: true
  end

  def success
    authorize @stripe_connect_account

    resp = Stripe::Account.retrieve(@stripe_connect_account.stripe_identifier)
    @stripe_connect_account.update!(
      details_submitted: resp.details_submitted?,
      charges_enabled: resp.charges_enabled?
    )

    redirect_to account_path
  end

  private

  def account_id
    params[:id]
  end

  def create_params
    {}
  end

  def link_params
    {
      account: account_id,
      refresh_url: link_stripe_connect_account_url(account_id),
      return_url: success_stripe_connect_account_url(account_id),
      type: 'account_onboarding'
    }
  end

  def set_user
    @user = Current.user
  end

  def set_stripe_connect_account
    @stripe_connect_account = StripeConnectAccount.find_by!(
      user: @user,
      stripe_identifier: account_id
    )
  end
end
