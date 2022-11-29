Rails.application.routes.draw do
  devise_for :headhunters, :users

  resources :comments
  resources :pages, only: [:index]
  resources :stars, only: [:index, :destroy, :create]
  resources :profiles, only: [:new, :index, :create, :edit, :show, :update]
  resources :applies do
    resources :proposals, only: [:show, :new, :create, :edit, :update, :destroy]
  end 
  resources :jobs, only: [:new, :index, :create, :edit, :show, :update] do
    get 'index_draft', on: :collection
    get 'index_archived', on: :collection
    get 'search', on: :collection 
    post 'drafted', on: :member
    post 'archived', on: :member 
    post 'published', on: :member  
  end

  namespace :api do
    namespace :v1 do
      resources :jobs, only: [:show, :index, :create, :update, :destroy]
    end  
  end


  root to: 'pages#index'
end
