require 'rails'
require 'rails/generators/active_record'

module Coalla
  module Cms
    module Image

      class InstallGenerator < ActiveRecord::Generators::Base
        argument :name, type: :string, default: ""
        source_root File.expand_path("../templates", __FILE__)
        class_option :prefixed, type: :boolean, default: false

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
          @prefixed = options.prefixed?
        end

        def copy_files
          migration_template "migration.rb.erb", "db/migrate/create_#{name.pluralize.underscore}.rb"
          template "model.rb.erb", "app/models/#{name.underscore}.rb"
          template "uploader.rb.erb", "app/uploaders/#{name.underscore}_uploader.rb"
        end

      end

    end
  end
end
