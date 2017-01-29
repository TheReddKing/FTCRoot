Rails.application.routes.draw do
    resources :regions
        root to: "visitors#index"
        # scope constraints: {format: :html} do
            resources :teams
                get 'teams/:id/plain', to: 'teams#plain'
            resources :events
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
        get 'events/:id/:name', to: 'events#show', as: 'fullevent'
        get 'league_meets/:id/:name', to: 'events#show'
        get 'league_meets/:id', to: 'events#show'
        get 'league_meets', to: 'events#index'
        get 'stats/highscores', to: "tools#stats"
        get "sitemap.xml" => "visitors#sitemap"


        namespace :api do
            namespace :v1 do
                resources :teams, only: [:show]
            end
        end

end
