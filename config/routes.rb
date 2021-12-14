Rails.application.routes.draw do
  devise_for :headhunters, :users

  resources :pages, :applies

  resources :jobs do
    post :enroll
  end

  resources :profiles do
    resources :comments
  end

  root to: 'pages#index'
end
