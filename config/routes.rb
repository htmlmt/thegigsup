Rails.application.routes.draw do
  resources :reposts
  resources :bands
  get 'bands/:id/:month/:year' => 'bands#show'
  resources :venues
  get 'venues/:id/:month/:year' => 'venues#show'
  resources :events do
      get :autocomplete_venue_name, :on => :collection
      get :autocomplete_band_name, :on => :collection
  end
  get 'calendar' => 'events#index'
  get 'calendar/:month/:year' => 'events#index'
  get 'events/:month/:year' => 'events#index', :as => 'month'
  root 'events#gigs', :as => 'gigs'
  get 'tags/:tag' => 'events#tags'
  get 'tags/:tag/:month/:year' => 'events#tags'
end
