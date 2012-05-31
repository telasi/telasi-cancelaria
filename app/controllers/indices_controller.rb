# -*- encoding : utf-8 -*-
class IndicesController < ApplicationController

  def index
    @indices = Index.all(:order => :prefix)
  end

  def show
    @index = Index.find(params[:id])
  end

  def new
    redirect_to(indices_url, :notice => 'არ გაქვთ ახალი ინდექსის დამატების უფლება!') and return if !get_current_user.can_edit_indices
    @index = Index.new
  end

  def edit
    redirect_to(indices_url, :notice => 'არ გაქვთ ინდექსის შეცვლის უფლება!') and return if !get_current_user.can_edit_indices
    @index = Index.find(params[:id])
  end

  def create
    @index = Index.new(params[:index])
    if @index.save
      redirect_to(@index, :notice => 'ინდექსი შექმნილია.')
    else
      render :action => "new"
    end
  end

  def update
    @index = Index.find(params[:id])
    if @index.update_attributes(params[:index])
      redirect_to(@index, :notice => 'ინდექსი შეცვლილია.')
    else
      render :action => "edit"
    end
  end

  def destroy
    redirect_to(indices_url, :notice => 'არ გაქვთ ინდექსის წაშლის უფლება!') and return if !get_current_user.can_edit_indices

    @index = Index.find(params[:id])
    redirect_to(@index, :notice => 'ვერ წავშლი: ეს ინდექსი გამოყენებაშია!') and return if Letter.where(:index_id => @index.id).count > 0    

    @index.destroy
  end
end
