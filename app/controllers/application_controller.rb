class ApplicationController < ActionController::Base
  before_filter :check_user, :except => [:login, :style]
  protect_from_forgery

  @PERMISSIONS = {
    :canc => ['index#new', 'index#edit', 'department#new', 'department#edit', 'employee#new', 'employee#edit'],
    :others => []
  }

  def get_current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def check_user
    unless session[:user_id]
      flash[:notice] = "გაიარეთ ავტორიზაცია"
      redirect_to login_url
    end
  end

end
