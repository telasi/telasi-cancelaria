# -*- encoding : utf-8 -*-
class NotCompletedTasks < Report

  def initialize
    super :page_size => 'A4', :margin => [50, 50]
    font "#{Rails.root}/lib/Arial Unicode.ttf", :size => 12
  end

  def to_pdf(letters, d1, d2)
    create_header(d1, d2)
    start_new_page
    create_details(letters, d1, d2)
    render
  end

  protected

  def create_header(d1, d2)
    text 'სამსახურეობრივი წერილი', :align => :center, :size => 16
    text 'Служебная записка', :align => :center, :size => 16
    move_down 40

    departments = Department.where(:print => true).order(:order_by)
    first_dept = departments[0]
    other_deps = ""
    departments[1..-1].each do |d|
      other_deps += "#{d.salutation}\n#{d.salutation_ru}\n\n"
    end

    table [
      ["ვის:\nКому:", "#{first_dept.salutation}\n#{first_dept.salutation_ru}"],
      ["ასლი:\nКопия:", other_deps],
      ["ვისგან:\nОт кого:", "კანცელარიის უფროსის მ. ხიმშიაშვილისაგან\nЗаведующей канцелярией М. Химшиашвили"],
      ["საკითხი:\nВопрос:", "შეუსრულებელი წერილების შესახებ\nНевыполненные письма"],
      ["თარიღი:\n\Дата:", Time.now.strftime('%d.%m.%Y')]
    ] do
      cells.style :borders => []
      row(4).style :borders => [:bottom]
    end

    move_down 20
    text "შეუსრულებელი წერილების რაოდენობა #{d1.strftime('%d.%m.%Y')}-დან #{d2.strftime('%d.%m.%Y')}-მდე."
    move_down 20
    text "Количество невыполненных писем с #{d1.strftime('%d.%m.%Y')} по #{d2.strftime('%d.%m.%Y')}."
  end

  def create_details(letters, d1, d2)
    #letters = get_not_completed_letters(d1, d2)
    items = letters.keys.map do |key|
      [
        "#{key.name}\n#{key.name_ru}",
        (letters[key].map do |l|
        "#{l.received.strftime('%d.%m.%Y')} №#{l.number}"
        end).join('; '),
        letters[key].size.to_s
      ]
    end
    count = items.size
    items = [["დეპარტამენტი\nДепартамент", "რეგისტრაციის ნომერი\nРегистрационный номер", "რაოდენობა\nКоличество"]] + items
    table items, :column_widths => [110, 300, 80] do
      row(0).style(:align => :center)
      rows(1..count).style(:size => 9)
    end
  end

end
