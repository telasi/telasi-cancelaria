Canc::Application.routes.draw do
  resources :letters
  resources :employees
  resources :departments
  resources :statuses
  resources :indices

  match '/home', :controller => :site, :action => :index
  match '/style', :controller => :style, :action => :style
  match '/add_department', :controller => :letters, :action => :add_department
  match '/remove_department', :controller => :letters, :action => :remove_department

  root :to => "site#index"
end
