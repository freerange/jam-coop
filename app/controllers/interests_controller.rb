# frozen_string_literal: true

class InterestsController < ApplicationController
  # GET /interests/new
  def new
    @interest = Interest.new
  end

  # POST /interests or /interests.json
  def create
    @interest = Interest.new(interest_params)

    respond_to do |format|
      if @interest.save
        format.html { redirect_to thankyou_url }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def thankyou; end

  private

  def interest_params
    params.require(:interest).permit(:email)
  end
end
