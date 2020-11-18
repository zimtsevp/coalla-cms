require 'rails'
require 'rails/generators/active_record'

module Coalla
  module Cms
    module News

      class ScaffoldGenerator < ::ActiveRecord::Generators::Base
        argument :name, type: :string, default: "Article"
        source_root File.expand_path("../templates", __FILE__)

        def setup_properties
          @class_name = name
          @collection_name = name.pluralize.underscore
          @instance_name = name.underscore
          @announce_image_uploader_name = "#{name}ImageUploader"
        end

        def create_model
          template "entity.rb.erb", "app/models/#{name.underscore}.rb"
          template "entity_image_uploader.rb.erb", "app/uploaders/#{name.underscore}_image_uploader.rb"
        end

        def create_model_migration
          @table_name = name.pluralize.underscore
          migration_template "migration.rb.erb", "db/migrate/create_#{name.pluralize.underscore}.rb"
        end

        def create_controller
          template 'entity_controller_template.rb.erb', "app/controllers/admin/#{name.pluralize.underscore}_controller.rb"
        end

        def add_routes
          sentinel = /namespace :admin do\s*$/
          routing_code = "  resources :#{name.pluralize.underscore}"
          inject_into_file 'config/routes.rb', "\n  #{routing_code}", {:after => sentinel, :verbose => false}
        end

        def create_views
          target_views_folder = "app/views/admin/#{@collection_name}"
          empty_directory target_views_folder
          %w(index new edit _form).each do |view_name|
            template "views/#{view_name}.haml.erb", "#{target_views_folder}/#{view_name}.haml"
          end
        end

      end
    end
  end
end