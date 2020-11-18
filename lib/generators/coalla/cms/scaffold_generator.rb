require 'rails'
require 'rails/generators/active_record'
require 'generators/coalla/cms/scaffold_helper'

module Coalla
  module Cms
    class ScaffoldGenerator < ActiveRecord::Generators::Base
      argument :name, type: :string

      source_root File.expand_path("../templates", __FILE__)

      include Coalla::Cms::ScaffoldHelper

      def setup_names
        @instance_name = name.underscore
        @collection_name = name.pluralize.underscore
        @class_name = name
      end

      def setup_table_columns
        a_class = name.constantize
        @table_columns = a_class.columns.reject{|c| [:id, :type, :created_at, :updated_at, :position].include?(c.name.to_sym) }.collect{|c| [c.name, c.type]}

        @reflections = {}
        a_class.reflections.values.find_all{|r| r.macro == :belongs_to}.each{|r| @reflections[r.foreign_key] = r}
      end

      def create_controller
        template 'controllers/admin/scaffold_controller_template.rb.erb', "app/controllers/admin/#{@collection_name}_controller.rb"
      end

      def create_views
        dir = "views/admin/"
        empty_directory "app/#{dir}/#{@collection_name}"

        templates = %w{_form edit index new}
        templates.each do |t|
          template "#{dir}/scaffold_template/#{t}.html.haml.erb", "app/#{dir}/#{@collection_name}/#{t}.html.haml"
        end
      end

      def setup_routes
        sentinel = /namespace :admin do\s*$/

        routing_code = "  resources :#{@collection_name}"
        in_root do
          inject_into_file 'config/routes.rb', "\n  #{routing_code}", { :after => sentinel, :verbose => false }
        end
      end

    end
  end
end
