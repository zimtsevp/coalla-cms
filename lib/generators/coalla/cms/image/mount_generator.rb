require 'rails'
require 'rails/generators/active_record'

module Coalla
  module Cms
    module Image

      class MountGenerator < ActiveRecord::Generators::Base
        argument :name, type: :string
        argument :field, type: :string
        class_option :prefixed, type: :boolean, default: false
        source_root File.expand_path("../templates", __FILE__)

        def setup_names
          @class_name = name
          @image_field = field
          @prefixed = options.prefixed?
        end

        def setup_fields
          @properties = {
              'file_name' => 'text',
              'content_type' => 'text',
              'size' => 'integer',
              'description' => 'text',

              'width' => 'integer',
              'height' => 'integer',

              'watermarked' => 'boolean',
              'source' => 'text'
          }
        end

        def copy_files
          migration_template "mount/migration.rb.erb", "db/migrate/add_#{@image_field}_field_to_#{@class_name.constantize.table_name}.rb"
          template "mount/uploader.rb.erb", "app/uploaders/#{@class_name.underscore}_#{@image_field}_uploader.rb"
        end

        def mount_uploader
          inject_into_class "app/models/#{@class_name.underscore}.rb", @class_name.constantize do
            "  mount_uploader :#{@image_field}, #{@class_name}#{@image_field.camelize}Uploader#{@prefixed? ", prefixed: true" : ""}\n"
          end
        end

      end

    end
  end
end
