# frozen_string_literal: true

class PayoutDetailsController < ApplicationController
  def new
    @payout_detail = PayoutDetail.new(user:)
    authorize @payout_detail
  end

  def create
    @payout_detail = PayoutDetail.new(payout_detail_params.merge(user:))
    authorize @payout_detail

    if @payout_detail.save
      redirect_to account_url, notice: 'Payout details added'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user
    Current.user
  end

  def payout_detail_params
    params.require(:payout_detail).permit(:name)
  end
end
