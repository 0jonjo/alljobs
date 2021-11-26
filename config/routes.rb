Rails.application.routes.draw do
  devise_for :headhunters, :users

  resources :pages, :jobs

  resources :users do
    resources :profiles
  end
  
  root to: 'pages#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
