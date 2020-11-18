module AdminHelper

  def admin_paginate(collection, options={})
    will_paginate collection, {renderer: BootstrapLinkRenderer, inner_window: 2}.merge(options)
  end

  def render_slides(form, title, collection_name, options = {})
    slider_class = options.delete(:slider_class_name) || SliderImage
    multiple = options.has_key?(:multiple) ? options.delete(:multiple) : true
    edit_allowed = options.has_key?(:edit_allowed) ? options.delete(:edit_allowed) : true
    render 'admin/common/slides', form: form, title: title, slides: collection_name, slider_class: slider_class, multiple: multiple, edit_allowed: edit_allowed
  end

  def generate_slider_template(form_builder, options = {})
    escape_javascript(generate_slider_html(form_builder, options))
  end

  def generate_slider_html(form_builder, options = {})
    options[:object] ||= options[:class].new
    options[:form_builder_local] ||= :lb
    options[:locals] ||= {}

    collection_name = options[:collection]
    form_builder.fields_for(collection_name, options[:object], child_index: 'NEW_RECORD') do |f|
      render(partial: options[:partial], locals: options[:locals].merge({options[:form_builder_local] => f}))
    end
  end

end