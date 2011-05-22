module ApplicationHelper

  def menu
    pages, sub_pages = all_pages
    pname, sname = current_page
    menu_html = ""
    pages.each do |p|
      lclass = pname == p[:name] ? 'selected' : 'common'
      menu_html += %Q{<li class="#{lclass}"><a href="#{p[:url]}">#{menu_item_caption(p[:name])}</a></li>}
    end
    "<ul>#{menu_html}</ul>".html_safe
  end

  def submenu
    pages, sub_pages = all_pages
    pname, sname = current_page
    sub_pages_on_this_page = sub_pages[pname]
    menu_html = ""
    if sub_pages_on_this_page and sub_pages_on_this_page.any?
      sub_pages_on_this_page.each do |s|
        aclass = sname == s[:name] ? 'selected' : 'common'
        menu_html += %Q{<a class="#{aclass}" href="#{s[:url]}">#{menu_item_caption(s[:name])}</a>}
      end
      %Q{<div id="submenu">#{menu_html}</div>}.html_safe
    else
      ""
    end
  end
  
  def menu_item_caption(name)
    case name
    when 'home'
      'საწყისი'
    when 'admin'
      'მართვა'
    when 'indices'
      'ინდექსები'
    else
      name
    end
  end

  def current_page
    cname = controller_name
    aname = controller.action_name
    if cname == 'site'
      pname = 'home'
    elsif cname == 'indices'
      pname = 'admin'
      sname = 'indecies'
    end
    [pname, cname]
  end

  def all_pages
    pages = [{:name => 'home', :url => home_url},  {:name => 'admin', :url => indices_url}]
    sub_pages = { 'home' => [], 'admin' => [{:name => 'indices', :url => indices_url}] }
    [pages, sub_pages]
  end

end