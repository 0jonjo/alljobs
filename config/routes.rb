Rails.application.routes.draw do
  devise_for :headhunters, :users

  resources :pages, :applies, :comments
  
  resources :profiles, only: [:new, :index, :create, :edit, :show, :update]

  resources :jobs, only: [:new, :create, :edit, :show, :update] do
    post :enroll
  end

  root to: 'pages#index'
end
