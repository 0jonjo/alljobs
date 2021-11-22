Rails.application.routes.draw do
  get 'pages/index'
  get 'jobs/index'
  devise_for :headhunters
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
