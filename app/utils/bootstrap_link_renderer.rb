class BootstrapLinkRenderer < WillPaginate::ActionView::LinkRenderer

  protected

  def html_container(html)
    tag(:div, tag(:ul, html, class: 'pagination'), class: 't-center')
  end

  def page_number(page)
    if page == current_page
      tag(:li, tag(:a, page), class: 'active')
    else
      tag(:li, link(page, page, rel: rel_value(page)))
    end
  end

  def gap
    text = @template.will_paginate_translate(:page_gap) { '&hellip;' }
    tag(:li, tag(:a, text), class: 'disabled')
  end

  def previous_page
    num = @collection.current_page > 1 && @collection.current_page - 1
    previous_or_next_page(num, @options[:previous_label])
  end

  def next_page
    num = @collection.current_page < @collection.total_pages && @collection.current_page + 1
    previous_or_next_page(num, @options[:next_label])
  end

  def previous_or_next_page(page, text)
    if page
      tag(:li, link(text, page))
    else
      tag(:li, tag(:a, text), class: 'disabled')
    end
  end

end