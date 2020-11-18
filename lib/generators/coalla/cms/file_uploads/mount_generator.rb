require 'rails'
require 'rails/generators/active_record'

module Coalla
  module Cms
    module FileUploads

      class MountGenerator < ActiveRecord::Generators::Base
        argument :name, type: :string
        argument :field_name, type: :string
        source_root File.expand_path("../templates", __FILE__)

        def setup_names
          @model_name = name.camelize
          @field_name = field_name
        end

        def copy_files
          migration_template 'add_column_migration.rb.erb', "db/migrate/add_#{@field_name}_field_to_#{@model_name.constantize.table_name}.rb"
        end

        def mount_uploader
          inject_into_class "app/models/#{@model_name.underscore}.rb", @model_name.constantize do
            """
  mount_uploader :#{@field_name}, FileUploader
"""
          end
        end

      end

    end
  end
end