Rails.application.routes.draw do
  devise_for :headhunters, :users

  resources :pages, :profiles, :applies

  resources :jobs do
    post :enroll
  end
 
  root to: 'pages#index'
end
