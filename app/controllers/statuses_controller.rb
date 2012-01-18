# encoding: utf-8
class StatusesController < ApplicationController

  def index
    @statuses = Status.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @statuses }
    end
  end

  def show
    @status = Status.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @status }
    end
  end

  def new
    redirect_to(statuses_url, :notice => 'არ გაქვთ ახალი სტატუსის დამატების უფლება!') and return if !get_current_user.can_edit_statuses
    @status = Status.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @status }
    end
  end

  def edit
    redirect_to(statuses_url, :notice => 'არ გაქვთ სტატუსის შეცვლის უფლება!') and return if !get_current_user.can_edit_statuses
    @status = Status.find(params[:id])
  end

  def create
    @status = Status.new(params[:status])

    respond_to do |format|
      if @status.save
        format.html { redirect_to(@status, :notice => 'სტატუსი შექმნილია.') }
        format.xml  { render :xml => @status, :status => :created, :location => @status }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @status.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @status = Status.find(params[:id])

    respond_to do |format|
      if @status.update_attributes(params[:status])
        format.html { redirect_to(@status, :notice => 'სტატუსი განახლებულია.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @status.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    redirect_to(statuses_url, :notice => 'არ გაქვთ სტატუსის წაშლის უფლება!') and return if !get_current_user.can_edit_statuses

    @status = Status.find(params[:id])
    redirect_to(@status, :notice => 'ვერ წავშლი: ეს სტატუსი გამოყენებაშია!') and return if Letter.where(:status_id => @status.id).count > 0
    @status.destroy

    respond_to do |format|
      format.html { redirect_to(statuses_url) }
      format.xml  { head :ok }
    end
  end
end
