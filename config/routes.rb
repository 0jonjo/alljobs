# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :headhunters, :users

  resources :pages, only: [:index]
  resources :stars, only: %i[index destroy create]
  resources :profiles, only: %i[new index create edit show update] do
    resources :comments
  end
  resources :applies do
    resources :proposals, only: %i[show new create edit update destroy] do
      post 'accept', on: :member
      post 'reject', on: :member
    end
  end
  resources :jobs, only: %i[new index create edit show update] do
    get 'index_draft', on: :collection
    get 'index_archived', on: :collection
    get 'search', on: :collection
    post 'drafted', on: :member
    post 'archived', on: :member
    post 'published', on: :member
  end

  namespace :api do
    namespace :v1 do
      resources :jobs, only: %i[show index create update destroy]
      resources :profiles, only: %i[show index create update destroy]
    end
  end

  root to: 'pages#index'
end
