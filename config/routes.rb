Rails.application.routes.draw do
  root 'static_pages#home'

  # Static pages routes
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

  # Gopay topup routes
  get '/users/:id/topup', to: 'users#topup_gopay', as: 'topup_gopay'
  patch  '/users/:id/topup', to: 'users#update_gopay', as: 'update_gopay'

  # Set location routes
  get '/drivers/:id/set-location', to: 'drivers#edit_location', as: 'edit_location'
  patch '/drivers/:id/set-location', to: 'drivers#update_location', as: 'update_location'

  # Bid jobs routes
  get '/drivers/:id/bid-job', to: 'drivers#edit_bid', as: 'edit_bid'
  patch '/drivers/:id/bid-job', to: 'drivers#update_bid', as: 'update_bid'

  # User new Order
  get '/users/:user_id/orders/new', to: 'orders#new', as: 'new_order'
  get '/users/:user_id/orders/create', to: 'orders#create', as: 'create_order'
  get '/users/:user_id/orders/confirm', to: 'orders#confirm_order', as: 'confirm_order'
  post '/users/:user_id/orders/confirm', to: 'orders#commit_order', as: 'commit_order'

  # Current Order
  get '/users/:id/orders/on-process', to: 'users#current_order', as: 'current_order'

  # Current Job
  get '/drivers/:id/jobs/on-process', to: 'drivers#current_job', as: 'current_job'
  patch '/drivers/:id/jobs/on-process', to: 'drivers#update_current_job', as: 'update_current_job'

  resources :users
  resources :drivers
  # resources :orders
end
