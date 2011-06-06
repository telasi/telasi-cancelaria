class LettersController < ApplicationController
  # GET /letters
  # GET /letters.xml
  def index
    @selected_index = params[:index_id] ? params[:index_id].to_i : 0
    if @selected_index > 0
      @letters = Letter.where(:index_id => @selected_index).order('id DESC')
    else
      @letters = Letter.all(:order => 'id DESC') 
    end
    @indecies = Index.all(:order => 'prefix')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @letters }
    end
  end

  # GET /letters/1
  # GET /letters/1.xml
  def show
    @letter = Letter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @letter }
    end
  end

  # GET /letters/new
  # GET /letters/new.xml
  def new
    @letter = Letter.new
    @letter.received = Time.new
    @selected_index = params[:index_id] ? params[:index_id].to_i : 0
    @letter.index = Index.find(@selected_index) if @selected_index > 0

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @letter }
    end
  end

  # GET /letters/1/edit
  def edit
    @letter = Letter.find(params[:id])
  end

  # POST /letters
  # POST /letters.xml
  def create
    @letter = Letter.new(params[:letter])
    @letter.status = Status.first(:order => 'order_by')
    if @letter.index
      if @letter.index.prefix == '#'
        @letter.number = "#{@letter.name.usubstr(0,1)}-#{@letter.index.last_number + 1}"
      else
        @letter.number = "#{@letter.index.prefix}/#{@letter.index.last_number + 1}"
      end
    end

    respond_to do |format|
      if @letter.save
        @letter.index.last_number = @letter.index.last_number + 1
        @letter.index.save!
        format.html { redirect_to(@letter, :notice => 'განცხადება შექმნილია.') }
        format.xml  { render :xml => @letter, :status => :created, :location => @letter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @letter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /letters/1
  # PUT /letters/1.xml
  def update
    @letter = Letter.find(params[:id])

    respond_to do |format|
      if @letter.update_attributes(params[:letter])
        format.html { redirect_to(@letter, :notice => 'განცხადება განახლებულია.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @letter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /letters/1
  # DELETE /letters/1.xml
  def destroy
    @letter = Letter.find(params[:id])
    @letter.destroy

    respond_to do |format|
      format.html { redirect_to(letters_url) }
      format.xml  { head :ok }
    end
  end

  def add_department
    @letter = Letter.find(params[:letter_id])
    @letter_department = LetterDepartment.new
    if request.post?
      dep = Department.find(params[:letter_department][:department_id])
      lds = LetterDepartment.where(:letter_id => @letter.id, :department_id => dep.id)
      if lds.empty?
        @letter_department.department = dep
        @letter_department.letter = @letter
        @letter_department.save
      end
      redirect_to @letter
    end
  end
  
  def remove_department
    l = Letter.find(params[:letter_id])
    d = Department.find(params[:department_id])
    ld = LetterDepartment.where(:department_id => d.id, :letter_id => l.id).first
    ld.destroy
    redirect_to l 
  end

  def add_employee
    @letter = Letter.find(params[:letter_id])
    @letter_employee = LetterEmployee.new
    if request.post?
      emp = Employee.find(params[:letter_employee][:employee_id])
      eds = LetterEmployee.where(:letter_id => @letter.id, :employee_id => emp.id)
      if eds.empty?
        @letter_employee.employee = emp
        @letter_employee.letter = @letter
        @letter_employee.save
      end
      redirect_to @letter
    end
  end

  
  def remove_employee
    l = Letter.find(params[:letter_id])
    e = Employee.find(params[:employee_id])
    le = LetterEmployee.where(:letter_id => l.id, :employee_id => e.id).first
    le.destroy
    redirect_to l
  end
  
end
