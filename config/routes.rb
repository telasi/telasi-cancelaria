Canc::Application.routes.draw do
  resources :users
  resources :letters
  resources :employees
  resources :departments
  resources :statuses
  resources :indices

  match '/home', :controller => :site, :action => :index
  match '/login', :controller => :site, :action => :login
  match '/logout', :controller => :site, :action => :logout
  match '/change_password', :controller => :site, :action => :change_password
  
  match '/style', :controller => :style, :action => :style
  match '/add_department', :controller => :letters, :action => :add_department
  match '/remove_department', :controller => :letters, :action => :remove_department
  match '/add_employee', :controller => :letters, :action => :add_employee
  match '/remove_employee', :controller => :letters, :action => :remove_employee
  match '/search', :controller => :letters, :action => :search

  root :to => "site#index"
end
