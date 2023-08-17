# frozen_string_literal: true

Rails.application.routes.draw do
  resources :interests, only: %i[new create] do
    member do
      get :confirm_email
    end
  end

  resources :artists, only: [] do
    resources :albums, only: %i[show]
  end

  get 'thankyou', to: 'interests#thankyou'
  get 'confirmation', to: 'interests#confirmation'

  root 'interests#new'
end
