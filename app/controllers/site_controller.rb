# -*- encoding : utf-8 -*-
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

  def change_password
    if request.post?
      user = get_current_user
      user.password = request[:password]
      user.password_confirmation = request[:password_confirmation]
      if user.save
        flash[:notice] = 'პაროლი შეცვლილია'
        redirect_to :action => 'index'
      else
        flash[:notice] = user.errors.full_messages
      end
    end
  end
  
end
