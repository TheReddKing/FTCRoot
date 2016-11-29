Rails.application.routes.draw do
  # root to: 'visitors#index'
  root to: "teams#map"

  get 'teams/twitter',                to: 'teams#twitter'
    resources :teams
    get "map", to: "teams#map"
    get 'search',                to: 'teams#search'
    get 'images/misc/quote_icon.png', to: "teams#nothing"
    get 'images/buttons/viewpost-right.png', to: "teams#nothing"
    get 'images/misc/quote-left.png', to: "teams#nothing"
end
