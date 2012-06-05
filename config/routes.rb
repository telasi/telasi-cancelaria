# -*- encoding : utf-8 -*-
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
  match '/resolution', controller: :letters, action: :resolution

  match '/add_user_index/:user_id', controller: :users, action: :add_user_index, as: :add_user_index
  delete '/delete_user_index/:id', controller: :users, action: :delete_user_index, as: :delete_user_index

  match '/not_completed_letters', :controller => :reports, :action => :not_completed_letters
  match '/completed_letters_by_index', :controller => :reports, :action => :completed_letters_by_index

  root :to => "site#index"
end
