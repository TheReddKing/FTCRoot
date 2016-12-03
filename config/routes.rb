Rails.application.routes.draw do
  resources :league_meets
  resources :ftcteam
  # root to: 'visitors#index'
  root to: "tools#map"

  get 'teams/twitter',                to: 'tools#twitter'
    resources :tools
    get "map", to: "tools#map"
    get 'search',                to: 'tools#search'
    get 'images/misc/quote_icon.png', to: "tools#nothing"
    get 'images/buttons/viewpost-right.png', to: "tools#nothing"
    get 'images/misc/quote-left.png', to: "tools#nothing"
end
