# frozen_string_literal: true

Rails.application.routes.draw do
  get  'log_in', to: 'sessions#new'
  post 'log_in', to: 'sessions#create'

  post 'sign_up', to: 'registrations#create'
  get  'sign_up', to: 'registrations#new'

  get  'about', to: 'pages#about'
  get  'terms', to: 'pages#terms'
  get  'blog', to: 'pages#blog'

  get 'account', to: 'users#show'
  get 'collection', to: 'collections#show'

  resources :sessions, only: %i[index show destroy]
  resource  :password, only: %i[update]
  resource :payout_detail, only: %i[create update]
  resolve('PayoutDetail') { [:payout_detail] }

  namespace :identity do
    resource :email,              only: %i[update]
    resource :email_verification, only: %i[show create]
    resource :password_reset,     only: %i[new edit create update]
  end

  resources :interests, only: %i[new create] do
    member do
      get :confirm_email
    end
  end

  namespace :admin do
    resources 'albums', only: %i[index]
  end

  resources :purchases, only: %i[show]

  resources :artists do
    resources :albums, only: %i[show new edit create update] do
      member do
        patch 'publish'
        patch 'unpublish'
        patch 'request_publication'
      end

      resources :purchases, only: %i[new create]
    end
  end

  resources :tracks, only: %i[] do
    member do
      post 'move_higher'
      post 'move_lower'
      get 'player'
    end
  end

  resources :email_subscription_changes, only: %i[create]
  resources :stripe_webhook_events, only: %i[create]

  get 'thankyou', to: 'interests#thankyou'
  get 'confirmation', to: 'interests#confirmation'

  get 'up' => 'healthchecks#show'

  root 'interests#new'

  direct :cdn do |model, options|
    expires_in = options.delete(:expires_in) { ActiveStorage.urls_expire_in }

    if model.respond_to?(:signed_id)
      route_for(
        :rails_service_blob_proxy,
        model.signed_id(expires_in:),
        model.filename,
        options.merge(Rails.application.config.cdn_url_options)
      )
    else
      route_for(
        :rails_blob_representation_proxy,
        model.blob.signed_id(expires_in:),
        model.variation.key,
        model.blob.filename,
        options.merge(Rails.application.config.cdn_url_options)
      )
    end
  end
end
