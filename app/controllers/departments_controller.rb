class DepartmentsController < ApplicationController
  def index
    @departments = Department.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @departments }
    end
  end

  def show
    @department = Department.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @department }
    end
  end

  def new
    redirect_to(departments_url, :notice => 'არ გაქვთ ახალი დირექციის დამატების უფლება!') and return if !get_current_user.can_edit_departmens
    @department = Department.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @department }
    end
  end

  def edit
    redirect_to(departments_url, :notice => 'არ გაქვთ დირექციის შეცვლის უფლება!') and return if !get_current_user.can_edit_departmens
    @department = Department.find(params[:id])
  end

  # POST /departments
  # POST /departments.xml
  def create
    @department = Department.new(params[:department])

    respond_to do |format|
      if @department.save
        format.html { redirect_to(@department, :notice => 'დირექცია შექმნილია.') }
        format.xml  { render :xml => @department, :status => :created, :location => @department }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @department.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /departments/1
  # PUT /departments/1.xml
  def update
    @department = Department.find(params[:id])

    respond_to do |format|
      if @department.update_attributes(params[:department])
        format.html { redirect_to(@department, :notice => 'დირექცია შეცვლილია.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @department.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.xml
  def destroy
    redirect_to(departments_url, :notice => 'არ გაქვთ დირექციის წაშლის უფლება!') and return if !get_current_user.can_edit_departmens
    @department = Department.find(params[:id])
    @department.destroy

    respond_to do |format|
      format.html { redirect_to(departments_url) }
      format.xml  { head :ok }
    end
  end
end
