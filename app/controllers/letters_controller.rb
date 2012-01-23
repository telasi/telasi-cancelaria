# encoding: utf-8
class LettersController < ApplicationController
  @@letter_per_page = 25

  def index
    @selected_index = params[:index_id] ? params[:index_id].to_i : 0
    @selected_year = params[:year] ? params[:year].to_i : Letter.years.last
    params[:year] = @selected_year.to_s
    @letters = search_support(params)
    @indecies = Index.all(:order => 'prefix')
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @letters }
    end
  end

  def show
    @letter = Letter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @letter }
    end
  end

  def new
    redirect_to(letters_url(:index_id => params[:index_id]), :notice => 'არ გაქვთ ახალი განცხადების დამატების უფლება!') and return if !get_current_user.can_edit_letters
    @letter = Letter.new
    @letter.received = Time.new
    @selected_index = params[:index_id] ? params[:index_id].to_i : 0
    @letter.index = Index.find(@selected_index) if @selected_index > 0

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @letter }
    end
  end

  def edit
    @letter = Letter.find(params[:id])
    redirect_to(@letter, :notice => 'არ გაქვთ განცხადების შეცვლის უფლება!') and return if !get_current_user.can_edit_letters
  end

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

  def update
    @letter = Letter.find(params[:id])

    respond_to do |format|
      if @letter.update_attributes(params[:letter])
        if @letter.status.update_sent_date and @letter.sent.nil?
          @letter.sent = Time.new
          @letter.save
        end
        format.html { redirect_to(@letter, :notice => 'განცხადება განახლებულია.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @letter.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    redirect_to(letters_url, :notice => 'არ გაქვთ განცხადების წაშლის უფლება!') and return if !get_current_user.can_edit_letters
    @letter = Letter.find(params[:id])
    @letter.destroy

    respond_to do |format|
      format.html { redirect_to(letters_url) }
      format.xml  { head :ok }
    end
  end

  def add_department
    @letter = Letter.find(params[:letter_id])
    redirect_to(@letter, :notice => 'არ გაქვთ დირექციის დამატების უფლება!') and return if !get_current_user.can_edit_letters
    @letter_department = LetterDepartment.new
    if request.post?
      dep = Department.find(params[:letter_department][:department_id])
      lds = LetterDepartment.where(:letter_id => @letter.id, :department_id => dep.id)
      if lds.empty?
        @letter_department.department = dep
        @letter_department.letter = @letter
        @letter_department.save
        @letter.review_assignments!
      end
      redirect_to @letter
    end
  end

  def remove_department
    l = Letter.find(params[:letter_id])
    redirect_to(l, :notice => 'არ გაქვთ დირექციის წაშლის უფლება!') and return if !get_current_user.can_edit_letters
    d = Department.find(params[:department_id])
    ld = LetterDepartment.where(:department_id => d.id, :letter_id => l.id).first
    ld.destroy
    l.review_assignments!
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
        @letter.review_assignments!
      end
      redirect_to @letter
    end
  end

  def remove_employee
    l = Letter.find(params[:letter_id])
    e = Employee.find(params[:employee_id])
    le = LetterEmployee.where(:letter_id => l.id, :employee_id => e.id).first
    le.destroy
    l.review_assignments!
    redirect_to l
  end

  def search
    @letters = search_support(params)
  end

  def search_support(conditions)
    where = []
    where_params = []
    if conditions[:index_id] and not conditions[:index_id].empty? and not conditions[:index_id] == '0'
      where.push('letters.index_id=?')
      where_params.push(conditions[:index_id])
    end
    if conditions[:status_id] and not conditions[:status_id].empty?
      where.push('letters.status_id=?')
      where_params.push(conditions[:status_id])
    end
    if conditions[:number] and not conditions[:number].empty?
      where.push('letters.number LIKE ?')
      where_params.push("%#{conditions[:number]}%")
    end
    if conditions[:own_number] and not conditions[:own_number].empty?
      where.push('letters.own_number LIKE ?')
      where_params.push("%#{conditions[:own_number]}%")
    end
    if conditions[:date1] and not conditions[:date1].empty?
      where.push('letters.received >= ?')
      where_params.push(Date.strptime(conditions[:date1], "%d-%b-%Y"))
    end
    if conditions[:date2] and not conditions[:date2].empty?
      where.push('letters.received <= ?')
      where_params.push(Date.strptime(conditions[:date2], "%d-%b-%Y"))
    end
    if conditions[:sdate1] and not conditions[:sdate1].empty?
      where.push('letters.sent >= ?')
      where_params.push(Date.strptime(conditions[:sdate1], "%d-%b-%Y"))
    end
    if conditions[:sdate2] and not conditions[:sdate2].empty?
      where.push('letters.sent <= ?')
      where_params.push(Date.strptime(conditions[:sdate2], "%d-%b-%Y"))
    end
    if conditions[:description] and not conditions[:description].empty?
      where.push('letters.description LIKE ?')
      where_params.push("%#{conditions[:description]}%")
    end
    if conditions[:name] and not conditions[:name].empty?
      where.push('letters.name LIKE ?')
      where_params.push("%#{conditions[:name]}%")
    end
    if conditions[:custnumb] and not conditions[:custnumb].empty?
      where.push('letters.custnumb LIKE ?')
      where_params.push("%#{conditions[:custnumb]}%")
    end
    if conditions[:address] and not conditions[:address].empty?
      where.push('letters.address LIKE ?')
      where_params.push("%#{conditions[:address]}%")
    end
    if conditions[:phone] and not conditions[:phone].empty?
      where.push('letters.phone LIKE ?')
      where_params.push("%#{conditions[:phone]}%")
    end
    if conditions[:year] and not conditions[:year].empty?
      where.push('letters.year = ?')
      where_params.push(conditions[:year])
    end

    user = get_current_user
    filter_deps = !user.canc_empl
    if filter_deps
      where.push('letter_departments.department_id=?')
      where_params.push(user.department_id)
    end

    if conditions[:department_id] and not conditions[:department_id].empty?
      where.push('letter_departments.department_id=?')
      where_params.push(conditions[:department_id])
      filter_deps = true
    end

    if conditions[:employee_id] and not conditions[:employee_id].empty?
      where.push('letter_employees.employee_id=?')
      where_params.push(conditions[:employee_id])
      filter_empls = true
    end

    where_cond = where.join(' and ')
    rails_conditions = [where_cond] + where_params
    from = []
    from.push(:letter_departments) if filter_deps
    from.push(:letter_employees)  if filter_empls
    
    @letters = Letter.joins(from).paginate(
      :page => conditions[:page],
      :per_page => @@letter_per_page,
      :conditions => rails_conditions,
      :order => 'id DESC')
  end

end
