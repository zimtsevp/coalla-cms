#encoding: utf-8
class TwitterFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::FormTagHelper

  COLS_CLASS = 'col-md-8'

  def errors
    return nil unless @object.errors.any?

    messages = @object.errors.full_messages.collect do |msg|
      "<p>#{ERB::Util.h(msg)}</p>".html_safe
    end

    content_tag(:div,
                content_tag(:div,
                            content_tag(:div,
                                        content_tag(:button, '&times;'.html_safe, class: 'close', type: 'button', :'data-dismiss' => 'alert') + messages.join('').html_safe,
                                        class: 'alert alert-danger'),
                            class: 'col-md-8 col-md-offset-2'),
                class: 'row')
  end

  def static_text(method, options = {})
    row method, content_tag(:p, static_text_formatter.format(method), class: 'form-control-static'), options
  end

  # Displays multi-line static text in form
  def static_memo_text(method, options = {})
    row method, simple_format(@object.send(method), class: 'form-control-static'), options
  end

  def string method, options = {}
    row method, text_field(method, with_default_options(options)), options
  end

  def combobox method, choices, options = {}, html_options = {}
    row method, select(method, choices, options, with_default_options(html_options)), div_class: options.delete(:div_class) || 'col-md-6'
  end

  def enum(method, options = {}, html_options = {})
    combobox method, object.class.send(method.to_s.pluralize).collect { |s| [s[0].humanize, s[0]] }, options, html_options
  end

  def enumerize(method, options = {}, html_options = {})
    combobox method, object.class.send(method).values.collect { |s| [s.text, s] }, options, html_options
  end

  def list_all_combobox(association_name, options = {}, html_options = {})
    collection_class = object.class.reflect_on_association(association_name).klass
    combobox("#{association_name}_id", collection_class.all.sort_by(&:name).map { |element| [element.name, element.id] }, {include_blank: true}.merge(options), html_options)
  end

  def textarea method, options = {}
    row method, text_area(method, with_default_options(options)), options
  end

  def checkbox method, options = {}
    row method, content_tag(:div, check_box(method, options), class: 'checkbox'), options
  end

  def wysiwyg method, options = {}
    textarea method, with_default_options(merge_classes(options, 'wymeditor'))
  end

  def ckeditor(method, options = {})
    row method, cktext_area(method, with_default_options(options))
  end

  def password method, options = {}
    row method, password_field(method, with_default_options(options)), options
  end

  def date method, options = {}
    string(method, merge_options({data: {'calendar-date' => true}, div_class: 'col-md-2'}, options))
  end

  def datetime(method, options = {})
    value = object.try(method).try(:strftime, '%Y-%m-%d %H:%M')
    string(method, merge_options({data: {'calendar-datetime' => true}, div_class: 'col-md-3', value: value}, options))
  end

  def time(method, options = {})
    value = object.try(method).try(:strftime, '%H:%M')
    string(method, merge_options({data: {'calendar-time' => true}, div_class: 'col-md-2', value: value}, options))
  end

  def save text = I18n.t('admin.common.save')
    submit text, name: :save, class: 'btn btn-success wymupdate'
  end

  def apply text = I18n.t('admin.common.apply')
    submit text, name: :apply, class: 'btn btn-default wymupdate'
  end

  def cancel
    @template.back_action
  end

  # Editing has_many collection
  # parameters: association - name of has_many association
  # association should be defined as accepts_nested_attributes with allow_destroy = true in model
  # You should create partial with name #{association)_fields
  def nested_fields_for(association)
    @template.render 'admin/common/nested_fields_for', f: self, section_name: @object.class.human_attribute_name(association), collection: association
  end

  def image_upload method, options = {}
    version = options[:version]

    uri = if version.present?
            @object.send("#{method}_url", version)
          else
            @object.send("#{method}_url")
          end

    if options[:size]
      url = uri || 'placeholder'
    else
      url = uri
    end

    upload_uri = options[:upload_path]
    unless upload_uri
      upload_uri = @template.admin_upload_image_path(image_class: @object.class.name.underscore, field: method)
    end
    @template.render partial: '/admin/common/image_upload_template', locals: {
        f: self, url: url, size: options[:size],
        version: version || '',
        title: options[:title] || '',
        text: options[:text],
        field: method, upload_uri: upload_uri,
        container: options[:parent_id] || upload_container_id(method),
        options: options.delete(:options) || {},
        image_style: options.delete(:image_style) || ''
    }
  end

  def file_upload method
    @template.render partial: '/admin/common/file_upload_template', locals: {
        f: self,
        field: method
    }
  end

  def multi_field(relation_name, options = {})
    reflection = self.object.class.reflections[relation_name] || self.object.class.reflections[relation_name.to_s]
    options = {search_field_name: :name,
               show_all_on_focus: false,
               use_cache: true,
               relation_model_name: reflection.klass.model_name.singular}.merge!(options)
    options[:source] ||= @template.admin_autocomplete_path(options[:relation_model_name], options[:search_field_name])
    string "#{relation_name}_tokens", title: self.object.class.human_attribute_name(relation_name),
           data: {
               multi_field: true,
               source: options[:source],
               pre: self.object.send("#{relation_name}_json", options[:search_field_name]),
               show_all_on_focus: options[:show_all_on_focus],
               use_cache: options[:use_cache],
               object_url_name: options[:object_url_name]}
  end

  def row(method, controls, options = {})
    label_class = options[:label_class] || 'control-label col-md-4 col-lg-2'
    label_tag = label(method, options[:title], class: label_class) unless options[:hide_label]
    options[:div_class] ||= COLS_CLASS
    div_tag = content_tag :div, controls.html_safe, class: options[:div_class]
    content_tag :div, "#{label_tag}#{div_tag}".html_safe, class: 'form-group'
  end

  private

  def upload_container_id(method)
    fake_method = "#{method}_upload"
    ActionView::Helpers::Tags::Base.new(@object_name, fake_method, @template).send(:tag_id)
  end

  def with_default_options(options)
    merge_classes(options, 'form-control')
    options
  end

  def merge_classes(options, *clazz)
    classes = [options[:class]].compact
    classes.push(*clazz)
    options[:class] = classes.uniq.join(' ')
    options
  end

  def merge_options(default_options, options)
    return default_options if options.blank?
    new_options = default_options.merge(options)
    if default_options.has_key?(:data) && options.has_key?(:data)
      new_options[:data] = default_options[:data].merge(options[:data])
    end
    new_options
  end

  def static_text_formatter
    @static_text_formatter ||= StaticTextFormatter.new(@object)
  end

end
