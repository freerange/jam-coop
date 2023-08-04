# frozen_string_literal: true

class InterestsController < ApplicationController
  # GET /interests/new
  def new
    @interest = Interest.new
  end

  # POST /interests or /interests.json
  def create
    @interest = Interest.find_or_create_by(interest_params)

    respond_to do |format|
      if @interest.save
        InterestsMailer.confirm(@interest).deliver_now
        format.html { redirect_to thankyou_url }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def confirm_email
    interest = Interest.find_by(confirm_token: params[:id])

    if interest
      interest.email_activate
      redirect_to confirmation_url
    else
      redirect_to root_url
    end
  end

  def thankyou; end

  def confirmation; end

  private

  def interest_params
    params.require(:interest).permit(:email)
  end
end
