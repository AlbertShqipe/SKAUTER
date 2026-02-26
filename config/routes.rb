Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  # Public read-only locations
  resources :locations, only: %i[index show] do
    resources :bookings, only: %i[new create]
    get "availability", to: "bookings#availability"
  end

  resources :regions,
          path: "explore",
          only: %i[index show],
          param: :slug

  # Admin-only full CRUD
  namespace :admin do
    resources :locations
    root to: "locations#index"
    resources :counties
    resources :venues, only: [:index, :show, :update]
    resources :bookings, only: %i[index show update]
  end

  # User favorites
  resources :locations, only: [] do
    resource :favorite, only: [:create, :destroy]
  end

  get "/favorites", to: "favorites#index", as: :favorites

  resources :venues, only: [:new, :create]
  get "list_venue", to: "venues#new"
end
