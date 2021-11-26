Rails.application.routes.draw do
  devise_for :headhunters, :users

  resources :pages, :jobs

  resources :profiles
  
  root to: 'pages#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
