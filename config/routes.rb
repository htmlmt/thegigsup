Rails.application.routes.draw do
  resources :bands
  resources :venues
  resources :events do
      get :autocomplete_venue_name, :on => :collection
      get :autocomplete_band_name, :on => :collection
  end
  get 'calendar' => 'events#index'
  get 'calendar/:month/:year' => 'events#index'
  get 'events/:month/:year' => 'events#index', :as => 'month'
  root 'events#gigs', :as => 'gigs'
end
