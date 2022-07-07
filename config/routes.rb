Rails.application.routes.draw do
  devise_for :headhunters, :users

  resources :comments, :pages, :applies
  resources :stars, only: [:index, :destroy, :create]
  resources :profiles, only: [:new, :index, :create, :edit, :show, :update]
  resources :jobs, only: [:new, :index, :create, :edit, :show, :update] do
    get 'search', on: :collection 
    post 'drafted', on: :member
    post 'archived', on: :member 
    post 'published', on: :member  
  end

  root to: 'pages#index'
end
