class SiteController < ApplicationController
  def index
  end
  
  def login
    if request.post?
      @user = User.authenticate(params[:name], params[:password])
      if @user
        session[:user_id] = @user.id
        redirect_to home_url
      else
        flash[:notice] = 'არასწორი მომხმარებლის სახელი/პაროლი.'
      end
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to home_url
  end

end
