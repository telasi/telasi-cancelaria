# encoding: utf-8
class EmployeesController < ApplicationController
  def index
    @employees = Employee.all(:order => 'order_by')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @employees }
    end
  end

  def show
    @employee = Employee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @employee }
    end
  end

  def new
    redirect_to(employees_url, :notice => 'არ გაქვთ ახალი თანამშრომლის დამატების უფლება!') and return if !get_current_user.can_edit_employees
    @employee = Employee.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @employee }
    end
  end

  def edit
    redirect_to(employees_url, :notice => 'არ გაქვთ თანამშრომლის შეცვლის უფლება!') and return if !get_current_user.can_edit_employees
    @employee = Employee.find(params[:id])
  end

  def create
    @employee = Employee.new(params[:employee])

    respond_to do |format|
      if @employee.save
        format.html { redirect_to(@employee, :notice => 'თანამშრომელი შექმნილია.') }
        format.xml  { render :xml => @employee, :status => :created, :location => @employee }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @employee.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @employee = Employee.find(params[:id])

    respond_to do |format|
      if @employee.update_attributes(params[:employee])
        format.html { redirect_to(@employee, :notice => 'თანამშრომელი შეცვლილია.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @employee.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    redirect_to(employees_url, :notice => 'არ გაქვთ თანამშრომლის წაშლის უფლება!') and return if !get_current_user.can_edit_employees
    @employee = Employee.find(params[:id])
    redirect_to(@employee, :notice => 'ვერ წავშლი: ეს თანამშრომელი გამოყენებაშია!') and return if LetterEmployee.where(:employee_id => @employee.id).count > 0
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to(employees_url) }
      format.xml  { head :ok }
    end
  end
end
