Rails.application.routes.draw do
  resources :bands
  resources :venues
  resources :events
  get 'events/:month/:year' => "events#index", :as => "month"
end
