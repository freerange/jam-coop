# frozen_string_literal: true

Rails.application.routes.draw do
  resources :interests, only: %i[new create] do
    member do
      get :confirm_email
    end
  end

  get 'thankyou', to: 'interests#thankyou'

  root 'interests#new'
end
