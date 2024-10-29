# frozen_string_literal: true

class PayoutDetailsController < ApplicationController
  before_action :set_user

  def create
    @payout_detail = PayoutDetail.new(payout_detail_params.merge(user: @user))
    authorize @payout_detail

    if @payout_detail.save
      redirect_to account_url, notice: 'Payout details added'
    else
      render 'users/show', status: :unprocessable_entity
    end
  end

  def update
    @payout_detail = @user.payout_detail
    raise ActiveRecord::RecordNotFound unless @payout_detail

    authorize @payout_detail

    if @payout_detail.update(payout_detail_params)
      redirect_to account_url, notice: 'Payout details updated'
    else
      render 'users/show', status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = Current.user
  end

  def payout_detail_params
    params.require(:payout_detail).permit(:name, :country)
  end
end
