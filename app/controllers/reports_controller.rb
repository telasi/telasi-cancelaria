# -*- encoding : utf-8 -*-
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

  def completed_letters_by_index
    @data = []
    if (params[:date1] and not params[:date1].empty?) and (params[:date2] and not params[:date2].empty?)
      @d1 = Date.strptime(params[:date1], "%d-%b-%Y")
      @d2 = Date.strptime(params[:date2], "%d-%b-%Y")
      Index.all(:order => 'prefix').each do |i|
        count = Letter.all(:conditions => ['received >= ? AND received <= ? AND index_id = ?', @d1, @d2, i.id]).count
        completed = Letter.all(:conditions => ['received >= ? AND received <= ? AND index_id = ? AND status_id NOT IN (1, 4)', @d1, @d2, i.id]).count
        @data.push({:index => i, :count => count, :completed => completed})
      end
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
