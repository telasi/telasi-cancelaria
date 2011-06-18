class IndicesController < ApplicationController
  # GET /indices
  # GET /indices.xml
  def index
    @indices = Index.all(:order => :prefix)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @indices }
    end
  end

  # GET /indices/1
  # GET /indices/1.xml
  def show
    @index = Index.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @index }
    end
  end

  # GET /indices/new
  # GET /indices/new.xml
  def new
    redirect_to(indices_url, :notice => 'არ გაქვთ ახალი ინდექსის დამატების უფლება!') and return if !get_current_user.can_edit_indices
    @index = Index.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @index }
    end
  end

  # GET /indices/1/edit
  def edit
    redirect_to(indices_url, :notice => 'არ გაქვთ ინდექსის შეცვლის უფლება!') and return if !get_current_user.can_edit_indices
    @index = Index.find(params[:id])
  end

  # POST /indices
  # POST /indices.xml
  def create
    @index = Index.new(params[:index])

    respond_to do |format|
      if @index.save
        format.html { redirect_to(@index, :notice => 'ინდექსი შექმნილია.') }
        format.xml  { render :xml => @index, :status => :created, :location => @index }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @index.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /indices/1
  # PUT /indices/1.xml
  def update
    @index = Index.find(params[:id])

    respond_to do |format|
      if @index.update_attributes(params[:index])
        format.html { redirect_to(@index, :notice => 'ინდექსი შეცვლილია.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @index.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /indices/1
  # DELETE /indices/1.xml
  def destroy
    redirect_to(indices_url, :notice => 'არ გაქვთ ინდექსის წაშლის უფლება!') and return if !get_current_user.can_edit_indices
    @index = Index.find(params[:id])
    @index.destroy

    respond_to do |format|
      format.html { redirect_to(indices_url) }
      format.xml  { head :ok }
    end
  end
end
