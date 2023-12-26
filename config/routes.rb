# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :admins
  devise_for :headhunters, :users

  resources :pages, only: [:index]
  resources :stars, only: %i[index destroy create]
  resources :profiles, only: %i[index show new create edit update] do
    resources :comments
  end
  resources :applies do
    resources :proposals do
      resources :proposal_comments
      post 'accept', on: :member
      post 'reject', on: :member
    end
  end
  resources :jobs do
    get 'index_draft', on: :collection
    get 'index_archived', on: :collection
    get 'search', on: :collection
    post 'drafted', on: :member
    post 'archived', on: :member
    post 'published', on: :member
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :jobs, only: %i[show index create update destroy] do
        resources :applies, only: %i[show index create destroy]
      end
      resources :profiles, only: %i[show index create update]
    end
  end

  root to: 'pages#index'
  mount Sidekiq::Web => '/sidekiq'
end
