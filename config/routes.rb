# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :headhunters, :users

  resources :stars, only: %i[index destroy create]
  resources :profiles, only: %i[index show new create edit update]
  resources :applies
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
        resources :applies, only: %i[show index create destroy] do
          resources :stars, only: %i[index create update destroy]
          resources :comments, only: %i[index create update destroy]
        end

        get 'stars', on: :member
      end
      resources :profiles, only: %i[show index create update]
      post 'auth_user', to: 'tokens#auth_user'
      post 'auth_headhunter', to: 'tokens#auth_headhunter'
    end
  end

  root to: 'pages#index'
end
