# frozen_string_literal: true

Rails.application.routes.draw do
  get  "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  get  "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  resources :sessions, only: [:index, :show, :destroy]
  resource  :password, only: [:edit, :update]
  namespace :identity do
    resource :email,              only: [:edit, :update]
    resource :email_verification, only: [:show, :create]
    resource :password_reset,     only: [:new, :edit, :create, :update]
  end
  root "home#index"
  resources :interests, only: %i[new create] do
    member do
      get :confirm_email
    end
  end

  get 'thankyou', to: 'interests#thankyou'
  get 'confirmation', to: 'interests#confirmation'

  # root 'interests#new'
end
