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
    if @user.save
      redirect_to(@user, :notice => 'მომხმარებელი შექმნილია.')
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to(@user, :notice => 'მომხმარებელი განახლებულია.')
    else
      render :edit
    end
  end

  def destroy
    redirect_to(users_url, :notice => 'არ გაქვთ მომხმარებლის წაშლის უფლება!') and return if !get_current_user.can_edit_users
    @user = User.find(params[:id])
    @user.destroy
    redirect_to(users_url)
  end

  ## USER <<=>> INDEX

  def add_user_index
    @user = User.find(params[:user_id])
    if request.post?
      @user_index = UserIndex.new(params[:user_index])
      @user_index.user = User.find(params[:user_id])
      redirect_to @user, notice: 'ინდექსი დამატებულია.' if @user_index.save
    else
      @user_index = UserIndex.new
    end
  end

  def delete_user_index
    @user_index = UserIndex.find(params[:id])
    user = @user_index.user
    @user_index.destroy
    redirect_to user, notice: 'ინდექსი წაშლილია.'
  end

end
