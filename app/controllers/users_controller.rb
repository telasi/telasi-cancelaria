# -*- encoding : utf-8 -*-
class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    redirect_to(users_url, :notice => 'არ გაქვთ ახალი მომხმარებლის დამატების უფლება!') and return if !get_current_user.can_edit_users
    @user = User.new
  end

  def edit
    redirect_to(users_url, :notice => 'არ გაქვთ მომხმარებლის შეცვლის უფლება!') and return if !get_current_user.can_edit_users
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    redirect_to(@user, :notice => 'მომხმარებელი შექმნილია.') if @user.save
  end

  def update
    @user = User.find(params[:id])
    redirect_to(@user, :notice => 'მომხმარებელი განახლებულია.') if @user.update_attributes(params[:user])
  end

  def destroy
    redirect_to(users_url, :notice => 'არ გაქვთ მომხმარებლის წაშლის უფლება!') and return if !get_current_user.can_edit_users
    @user = User.find(params[:id])
    @user.destroy
    redirect_to(users_url)
  end

end
