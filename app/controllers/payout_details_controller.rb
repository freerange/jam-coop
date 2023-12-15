# frozen_string_literal: true

class PayoutDetailsController < ApplicationController
  def new
    @payout_detail = PayoutDetail.new(user:)
    authorize @payout_detail
  end

  def edit
    @payout_detail = user.payout_detail
    raise ActiveRecord::RecordNotFound unless @payout_detail

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

  def update
    @payout_detail = user.payout_detail
    raise ActiveRecord::RecordNotFound unless @payout_detail

    authorize @payout_detail

    if @payout_detail.update(payout_detail_params)
      redirect_to account_url, notice: 'Payout details updated'
    else
      render :edit, status: :unprocessable_entity
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
