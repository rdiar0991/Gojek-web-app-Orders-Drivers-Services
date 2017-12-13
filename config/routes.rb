Rails.application.routes.draw do
  root 'static_pages#home'

  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  # Signup routes
  get '/users/signup', to: 'users#new', as: 'user_signup'
  post '/users/signup', to: 'users#create'
  get '/drivers/signup', to: 'drivers#new', as: 'driver_signup'
  post '/drivers/signup', to: 'drivers#create'

  # Login routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/users/:id/topup', to: 'users#topup_gopay', as: 'topup_gopay'
  patch  '/users/:id/topup', to: 'users#update_gopay', as: 'update_gopay'

  resources :users
  resources :drivers
end
