Rails.application.routes.draw do
  devise_for :headhunters, :users

  resources :comments, :pages

  resources :applies do
    post :star_select
  end
  
  resources :stars, only: [:index, :destroy]
  resources :profiles, only: [:new, :index, :create, :edit, :show, :update] do
    post :star_select
  end

  resources :jobs, only: [:new, :index, :create, :edit, :show, :update] do
    post :enroll
  end

  root to: 'pages#index'
end
