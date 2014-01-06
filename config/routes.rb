Mosh2::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :locations do
    resources :workstations
  end
  resources :location_types
  resources :hardwares
  resources :hardware_statuses
  resources :hardware_types
  resources :workstations do
    resources :hardwares
  end
  resources :workstation_types

  resources :inventory, only: :index
  devise_for :users
  root to: 'home#index'
end
