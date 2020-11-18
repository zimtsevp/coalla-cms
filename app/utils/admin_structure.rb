#encoding: utf-8
class AdminStructure

  include Rails.application.routes.url_helpers

  Section = Struct.new(:name, :path, :icon, :description, :counter, :show_menu_counter, :creation_path) do

    def show_menu_counter?
      show_menu_counter.present?
    end

  end

  Separator = Struct.new(:title)

  CONFIG_FILE_NAME = 'structure.rb'

  attr_accessor :sections

  def initialize(controller)
    @controller = controller
    @sections = []
    load_sections_from_config
  end

  def menu_items
    dashboard_item = Section.new(I18n.t('admin.common.dashboard'), admin_dashboard_path, 'glyphicon glyphicon-align-left')
    [dashboard_item] + @sections
  end

  def sections
    @sections.find_all { |section| section.is_a?(Section) }
  end

  private

  def load_sections_from_config
    config_path = Rails.root.join('config', CONFIG_FILE_NAME).to_s
    if File.exist?(config_path)
      instance_eval(File.read(config_path), config_path)
    end
  end

  # Options:
  # creation_path - false or path string
  def section(section_reference, options = {})
    path = options.delete(:path)
    icon = options.delete(:icon)
    description = options.delete(:description)
    counter = options.delete(:counter)
    show_menu_counter = options.delete(:show_menu_counter)
    creation_path = options.delete(:creation_path)
    if section_reference.is_a?(Class)
      section_name = section_reference.model_name.human
      path = send("admin_#{section_reference.model_name.route_key}_path") unless path
      counter = ->() { section_reference.count } unless counter
      creation_path = send("new_admin_#{section_reference.model_name.singular}_path") if creation_path.nil?
    else
      section_name = section_reference
    end
    @sections << Section.new(section_name, path, icon, description, counter, show_menu_counter, creation_path)
  end

  def lookup_section(section_references = 'Настройки', category = nil, options = {})
    default_options = options.merge(path: send('admin_lookups_index_path', category: category),
                                    icon: 'glyphicon glyphicon-wrench',
                                    description: 'Раздел содержит различные настройки и тексты')
    section(section_references, default_options)
  end

  def meta_tags_section(section_references = 'Мета-тэги', options = {})
    default_options = options.merge(path: send('admin_meta_tags_path'),
                                    icon: 'glyphicon glyphicon-tag',
                                    description: 'Раздел содержит мета-тэги')
    section(section_references, default_options)
  end

  def separator(title)
    @sections << Separator.new(title)
  end

end