#encoding: utf-8
module TwitterBuilderHelper

  ALIGN_CLASSES = {left: 't-left', center: 't-center', right: 't-right'}

  class ColumnDefinition
    attr_accessor :title, :cols, :col_class, :value_extractor, :align

    def value(item, context = self)
      self.value_extractor.call(item)
    end

  end

  class ActionsColumnDefinition < ColumnDefinition

    def initialize
      self.title = I18n.t('admin.common.actions')
      @actions = []
    end

    def cols
      @cols || @actions.size % 2 + @actions.size / 2
    end

    def col_class
      "col-xs-#{cols}"
    end

    def cols=(value)
      @cols = value
    end

    def value(item, context = self)
      @actions.collect do |action|
        options = action.second
        if options[:if]
          context.instance_exec(item, &action.first) if options[:if].call(item)
        else
          context.instance_exec(item, &action.first)
        end
      end.compact.join(' ').html_safe
    end

    def action(method, options = {})
      @actions << case method
                    when :edit
                      [->(item) { edit_link(send("edit_admin_#{item.class.name.underscore.sub('/', '_')}_path", item)) }, options]
                    when :delete
                      [->(item) { delete_link([:admin, item]) }, options]
                    when Proc
                      [method, options]
                    else
                      raise "unsupported method: #{method.inspect}"
                  end
    end

  end

  class TableBuilder

    def initialize(parent, model_class)
      @parent, @model_class = parent, model_class
      @columns = []
      @actions_column = ActionsColumnDefinition.new
      @action_column_on_left = false
      @table_helpers = TableHelpers.for(@model_class, @parent)
    end

    def content collection, &block
      @collection = collection
      block.call(self) if block_given?
      create_content
    end

    # Метод добавляет столбец к таблице
    def column(method, options = {})
      helper = @table_helpers[method]
      cd = ColumnDefinition.new
      cd.title = options[:title] || I18n.t("activerecord.attributes.#{@model_class.model_name.singular}.#{method}")
      cd.cols = options[:cols]
      cd.col_class = options[:class]
      cd.value_extractor = ->(item) { helper.format_value(item, options[:format]) }
      cd.align = options[:align] || helper.respond_to?(:align) && "t-#{helper.align}"
      @columns << cd
    end

    # Метод позволяет передать блок, который должен вычислять класс для строки. В этот блок передается объект,
    # по которому данная строка рендерится. Таким образом, можно управлять, например, цветом строки в зависимости
    # от состояния объекта (статусы заказов и прочее).
    def row_class lmb
      @row_class = lmb
    end

    # Метод добавляет кнопку в столбец действий
    def action(value, options = {})
      add_action(value, options)
    end

    # Метод добавляет кнопку редактирования сущности в столбец действий
    def edit(options = {})
      add_action(:edit, options)
    end

    # Метод добавляет кнопку удаления сущности в столбец действий
    def delete(options = {})
      add_action(:delete, options)
    end

    # Метод добавляет кнопки добавления и удаления сущностей в столбец действий
    def edit_and_delete(options = {})
      self.edit(options)
      self.delete(options)
    end

    private

    def add_action(value, options)
      @action_column_on_left = true if @columns.empty?
      @actions_column.action(value, options)
    end

    def all_columns
      @action_column_on_left ? [@actions_column] + @columns : @columns + [@actions_column]
    end

    def create_content
      @parent.render(partial: '/admin/common/table_template', locals: {definitions: all_columns, items: @collection, row_class: @row_class})
    end
  end

  def twitter_form_for(name, *args, &block)
    options = args.extract_options!
    form_for(name, *(args << options.deep_merge(builder: TwitterFormBuilder, html: {class: 'form-horizontal'})), &block)
  end

  def field_set title = nil, &block
    content = capture(self, &block)
    content = content_tag(:legend, title) + content if title
    content_tag :fieldset, content
  end

  def actions &block
    content = capture(self, &block)
    content_tag :div, content, class: 'well'
  end

  def standard_actions(form)
    fixed_actions { form.save + form.apply + form.cancel }
  end

  def fixed_actions &block
    panel_tag = actions(&block)
    content_tag :div, panel_tag, class: 'action-bar'
  end

  def flash_warning_messages
    r = if flash[:admin_warning]
          "<div class='row'>
            <div class='col-md-8 col-md-offset-2'>
              <div class='alert alert-danger'>
                <button data-dismiss='alert' class='close' type='button'>&times;</button>
                <p>#{h(flash[:admin_warning])}</p>
              </div>
            </div>
          </div>"
        end
    r && r.html_safe
  end

  def flash_alert_messages
    r = if flash[:alert]
          "<div class='row'>
            <div class='col-md-8 col-md-offset-2'>
              <div class='alert alert-danger'>
                <button data-dismiss='alert' class='close' type='button'>&times;</button>
                <p>#{h(flash[:alert])}</p>
              </div>
            </div>
          </div>"
        end
    r && r.html_safe
  end

  def flash_success_messages
    r = if flash[:admin_success]
          "<div class='row'>
            <div class='col-md-8 col-md-offset-2'>
              <div class='alert alert-success'>
                <button data-dismiss='alert' class='close' type='button'>&times;</button>
                <p>#{h(flash[:admin_success])}</p>
              </div>
            </div>
          </div>"
        end
    r && r.html_safe
  end

  def flash_messages
    [flash_warning_messages, flash_success_messages].compact.join.html_safe
  end

  def create_link path
    content = "<i class='glyphicon glyphicon-plus'></i>&nbsp;&nbsp;#{I18n.t('admin.common.new')}".html_safe
    link_to content, path, class: 'btn btn-success'
  end

  def sort_link path
    content = "<i class='glyphicon glyphicon-random'></i>&nbsp;&nbsp;#{I18n.t('admin.common.sort')}".html_safe
    link_to content, path, class: 'btn btn-primary'
  end

  def edit_link path
    content = "<i class='glyphicon glyphicon-pencil'></i>".html_safe
    link_to content, path, class: 'btn btn-default btn-xs', title: I18n.t('admin.common.edit')
  end

  def delete_link path
    content = "<i class='glyphicon glyphicon-trash'></i>".html_safe
    link_to content, path, data: {confirm: I18n.t('admin.common.sure')}, method: :delete, class: 'btn btn-danger btn-xs', title: I18n.t('admin.common.delete')
  end

  def cancel_action path, name = I18n.t('admin.common.cancel')
    link_to name, path, class: 'btn btn-default'
  end

  def back_action name = I18n.t('admin.common.return'), path = back_uri
    link_to name, path, class: 'btn btn-default'
  end

  def table_for a_class
    TableBuilder.new(self, a_class)
  end

  def th_class(column)
    klass = []
    klass << "col-xs-#{column.cols}" if column.cols
    klass << ALIGN_CLASSES[column.align] if column.align
    klass.join(' ')
  end

  def tr_class(row_class, item)
    row_class && row_class.call(item)
  end

  def td_class(column)
    klass = []
    klass << column.col_class
    klass << ALIGN_CLASSES[column.align] if column.align
    klass.join(' ')
  end

end