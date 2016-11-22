Rails.application.routes.draw do
  root to: 'visitors#index'
  get "/teams/map" => "teams#map"
  resources :teams
end
