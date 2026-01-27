Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  # Public read-only locations
  resources :locations, only: %i[index show]
  resources :regions, only: %i[index show], param: :slug

  # Admin-only full CRUD
  namespace :admin do
    resources :locations
    root to: "locations#index"
  end
end
