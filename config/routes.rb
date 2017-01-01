Rails.application.routes.draw do
  resources :regions
    root to: "tools#map"
    # scope constraints: {format: :html} do
        resources :teams
            get 'teams/:id/plain', to: 'teams#plain'
        resources :league_meets
    # end
  # resources :ftcteam
  # root to: 'visitors#index'

  get 'teams/twitter',                to: 'tools#twitter'
    resources :tools
    get "map", to: "tools#map"
    get 'search',                to: 'tools#search'
    get 'images/misc/quote_icon.png', to: "tools#nothing"
    get 'images/buttons/viewpost-right.png', to: "tools#nothing"
    get 'images/misc/quote-left.png', to: "tools#nothing"
    get 'teams/:id/:name', to: 'teams#show', as: 'fullname'
    get 'league_meets/:id/:name', to: 'league_meets#show', as: 'fullmeet'
    get "sitemap.xml" => "visitors#sitemap"
end
