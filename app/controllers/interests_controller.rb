# frozen_string_literal: true

class InterestsController < ApplicationController
  skip_before_action :authenticate
  before_action :skip_authorization

  def new
    @interest = Interest.new
  end

  def create
    @interest = Interest.find_or_create_by(interest_params)

    if @interest.save
      InterestsMailer.confirm(@interest).deliver_later
      redirect_to thankyou_path
    else
      render :new, status: :unprocessable_content
    end
  end

  def confirm_email
    interest = Interest.find_by(confirm_token: params[:id])

    if interest
      interest.email_activate
      redirect_to confirmation_path
    else
      redirect_to root_path
    end
  end

  def thankyou; end

  def confirmation; end

  private

  def interest_params
    params.expect(interest: [:email])
  end
end
