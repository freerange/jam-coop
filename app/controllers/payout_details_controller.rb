# frozen_string_literal: true

class PayoutDetailsController < ApplicationController
  before_action :set_user

  def create
    @payout_detail = PayoutDetail.new(payout_detail_params.merge(user: @user))
    authorize @payout_detail

    if @payout_detail.save
      redirect_to account_path, notice: 'Payout details added'
    else
      render 'users/show', status: :unprocessable_content
    end
  end

  def update
    @payout_detail = @user.payout_detail
    raise ActiveRecord::RecordNotFound unless @payout_detail

    authorize @payout_detail

    if @payout_detail.update(payout_detail_params)
      redirect_to account_path, notice: 'Payout details updated'
    else
      render 'users/show', status: :unprocessable_content
    end
  end

  private

  def set_user
    @user = Current.user
  end

  def payout_detail_params
    params.expect(payout_detail: %i[name country])
  end
end
