# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :headhunters, :users

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
