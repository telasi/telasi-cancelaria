Canc::Application.routes.draw do
  resources :indices
  match '/home', :controller => :site, :action => :index
  match '/style', :controller => :style, :action => :style
  root :to => "site#index"
end
