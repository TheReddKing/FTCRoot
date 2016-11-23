Rails.application.routes.draw do
  # root to: 'visitors#index'
  root to: "teams#map"

  get 'teams/twitter',                to: 'teams#twitter'
    resources :teams
    get "map", to: "teams#map"
    get 'search/:id',                to: 'teams#search'
end
