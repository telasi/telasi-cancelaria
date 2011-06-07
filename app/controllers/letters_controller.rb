  class LettersController < ApplicationController
    @@letter_per_page = 25
    # GET /letters
    # GET /letters.xml
    def index
      @selected_index = params[:index_id] ? params[:index_id].to_i : 0
  
      if @selected_index > 0
        @letters = Letter.paginate(
                :page => params[:page],
                :per_page => @@letter_per_page,
                :conditions => ['index_id=?', @selected_index],
                :order => 'id DESC')
      else
        @letters = Letter.paginate(
                :page => params[:page],
                :per_page => @@letter_per_page,
                :order => 'id DESC') 
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

    def search
      where = []
      where_params = []
      if params[:index_id] and not params[:index_id].empty?
        where.push('index_id=?')
        where_params.push(params[:index_id])
      end
      if params[:status_id] and not params[:status_id].empty?
        where.push('status_id=?')
        where_params.push(params[:status_id])
      end
      if params[:number] and not params[:number].empty?
        where.push('number LIKE ?')
        where_params.push("%#{params[:number]}%")
      end
      if params[:own_number] and not params[:own_number].empty?
        where.push('own_number LIKE ?')
        where_params.push("%#{params[:own_number]}%")
      end

      if params[:date1] and not params[:date1].empty?
        where.push('received >= ?')
        where_params.push(Date.strptime(params[:date1], "%d-%b-%Y"))
      end

      if params[:date2] and not params[:date2].empty?
        where.push('received <= ?')
        where_params.push(Date.strptime(params[:date2], "%d-%b-%Y"))
      end

      if params[:sdate1] and not params[:sdate1].empty?
        where.push('sent >= ?')
        where_params.push(Date.strptime(params[:sdate1], "%d-%b-%Y"))
      end

      if params[:sdate2] and not params[:sdate2].empty?
        where.push('sent <= ?')
        where_params.push(Date.strptime(params[:sdate2], "%d-%b-%Y"))
      end
      
      if params[:description] and not params[:description].empty?
        where.push('description LIKE ?')
        where_params.push("%#{params[:description]}%")
      end

      if params[:name] and not params[:name].empty?
        where.push('name LIKE ?')
        where_params.push("%#{params[:name]}%")
      end

      if params[:custnumb] and not params[:custnumb].empty?
        where.push('custnumb LIKE ?')
        where_params.push("%#{params[:custnumb]}%")
      end

      if params[:address] and not params[:address].empty?
        where.push('address LIKE ?')
        where_params.push("%#{params[:address]}%")
      end

      if params[:phone] and not params[:phone].empty?
        where.push('phone LIKE ?')
        where_params.push("%#{params[:phone]}%")
      end

      unless where.empty?
        where_cond = where.join(' and ')
        conditions = [where_cond] + where_params
        @letters = Letter.paginate(
            :page => params[:page],
            :per_page => @@letter_per_page,
            :conditions => conditions,
            :order => 'id DESC')
      else
        @letters = nil
      end
    end
  
  end