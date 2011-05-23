Canc::Application.routes.draw do
  resources :departments

  resources :statuses

  resources :indices
  match '/home', :controller => :site, :action => :index
  match '/style', :controller => :style, :action => :style
  root :to => "site#index"
end
