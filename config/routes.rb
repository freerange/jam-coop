# frozen_string_literal: true

Rails.application.routes.draw do
  mount Lookbook::Engine, at: '/lookbook' if Rails.env.development?

  root 'pages#home'

  get  'log_in', to: 'sessions#new'
  post 'log_in', to: 'sessions#create'

  post 'sign_up', to: 'registrations#create'
  get  'sign_up', to: 'registrations#new'

  get  'about', to: 'pages#about'
  get  'terms', to: 'pages#terms'
  get  'blog',  to: redirect('/newsletters')

  resources :newsletters, only: %i[index]

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

  patch 'users/newsletter_preference', to: 'users#update_newsletter_preference'

  resources :interests, only: %i[new create] do
    member do
      get :confirm_email
    end
  end

  namespace :admin do
    resources 'albums', only: %i[index]
    resources 'newsletters', only: %i[new create edit update]
  end

  resources :purchases, only: %i[show]

  resources :artists do
    resources :albums, only: %i[show new edit create update] do
      resources :purchases, only: %i[new create]
    end
  end

  resources :albums, only: %i[index]

  resources :tracks, only: %i[] do
    member do
      post 'move_higher'
      post 'move_lower'
    end
  end

  resources :tags, only: %i[show]

  resources :email_subscription_changes, only: %i[create]
  resources :stripe_webhook_events, only: %i[create]

  get 'thankyou', to: 'interests#thankyou'
  get 'confirmation', to: 'interests#confirmation'

  get 'up' => 'healthchecks#show'

  direct :cdn do |model, options|
    expires_in = options.delete(:expires_in) { ActiveStorage.urls_expire_in }

    if model.respond_to?(:signed_id)
      route_for(
        :rails_service_blob_proxy,
        model.signed_id(expires_in:),
        model.filename,
        options.merge(Rails.configuration.cdn_url_options)
      )
    else
      route_for(
        :rails_blob_representation_proxy,
        model.blob.signed_id(expires_in:),
        model.variation.key,
        model.blob.filename,
        options.merge(Rails.configuration.cdn_url_options)
      )
    end
  end
end
