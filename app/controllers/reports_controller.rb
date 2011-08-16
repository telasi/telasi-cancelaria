class ReportsController < ApplicationController
  def not_completed_letters
    if (params[:date1] and not params[:date1].empty?) and (params[:date2] and not params[:date2].empty?)
      @d1 = Date.strptime(params[:date1], "%d-%b-%Y")
      @d2 = Date.strptime(params[:date2], "%d-%b-%Y")
      @letters = get_not_completed_letters(@d1, @d2)
      @departments = get_print_departments
    end
    render :layout => 'print' if params['print'] == 'ok'
  end

  private

  def get_not_completed_letters(d1, d2)
    letters = Letter.all(:conditions => ["status_id IN (1, 4) AND received >= ? AND received <= ?", d1, d2], :order => 'id DESC')
    map = {}
    letters.each do |l|
      l.employees.each do |e|
        if e.print
          empl_letters = map[e]
          empl_letters = [] and map[e] = empl_letters unless empl_letters
          empl_letters.push(l)
        end
      end
    end
    map
  end

  def get_print_departments
    Department.where(:print => true).order(:order_by)
  end
  
end
