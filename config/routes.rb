Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  # Public read-only locations
  resources :locations, only: %i[index show]
  resources :regions,
          path: "explore",
          only: %i[index show],
          param: :slug

  # Admin-only full CRUD
  namespace :admin do
    resources :locations
    root to: "locations#index"
    resources :counties
  end

  # User favorites
  resources :locations, only: [] do
    resource :favorite, only: [:create, :destroy]
  end

  get "/favorites", to: "favorites#index", as: :favorites
end
