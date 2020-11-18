require 'standalone_typograf'

module CommonHelper

  def copyright(start_year)
    current_year = Date.today.year
    if current_year > start_year
      "#{start_year}&nbsp;-&nbsp;#{current_year}".html_safe
    else
      "#{current_year}"
    end
  end

  def hide_style(style)
    'display: none;' + style
  end

  def ty(text)
    ::StandaloneTypograf::Typograf.new(text, mode: :html).prepare.html_safe
  end

end