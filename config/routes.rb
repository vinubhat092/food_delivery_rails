Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      post 'registration', to: 'registration#create'
      post 'login', to:'login#create'
      delete 'logout', to: 'logout#create'
      resources :users, only:[:index,:show,:update,:destroy]
      resources :restaurants, only:[:index,:show,:create,:update,:destroy]
      resources :menuitems, only:[:index,:show,:create,:update,:destroy]
      resources :carts, only:[:index,:create,:update,:destroy,:show]
      resources :orders, only:[:index,:create,:update,:destroy]
      get 'analytics', to: 'analytics#order_stats'
      post 'logout', to:'logout#create'
    end
  end
end
