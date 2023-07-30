# frozen_string_literal: true

Rails.application.routes.draw do
  resources :interests, only: %i[new create]
  get 'thankyou', to: 'interests#thankyou'

  root 'interests#new'
end
