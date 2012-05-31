# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  before_filter :check_user, :except => [:login, :style]
  protect_from_forgery

  def get_current_user
    unless @__user_initialized
      @__user = User.find(session[:user_id]) if session[:user_id] rescue nil
      @__user_initialized = true
    end
    @__user
  end

  def check_user
    unless session[:user_id]
      flash[:notice] = "გაიარეთ ავტორიზაცია"
      redirect_to login_url
    end
  end

end
