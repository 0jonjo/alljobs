Rails.application.routes.draw do
  devise_for :headhunters, :users

  resources :applies, :comments, :pages, :stars
  
  resources :profiles, only: [:new, :index, :create, :edit, :show, :update]

  resources :jobs, only: [:new, :index, :create, :edit, :show, :update] do
    post :enroll
  end

  root to: 'pages#index'
end
