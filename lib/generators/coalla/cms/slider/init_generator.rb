require 'rails'
require 'rails/generators/active_record'

module Coalla
  module Cms
    module Slider

      class InitGenerator < ::ActiveRecord::Generators::Base
        argument :name, type: :string, default: 'SliderImage'
        source_root File.expand_path('../templates', __FILE__)

        def setup
          @class_name = name
          @uploader_name = "#{@class_name}Uploader"
          @table_name = @class_name.pluralize.underscore
        end

        def create_model
          template 'slider_image.rb.erb', "app/models/#{@class_name.underscore}.rb"
          template 'slider_image_uploader.rb.erb', "app/uploaders/#{@uploader_name.underscore}.rb"
        end

        def create_upload_migration
          migration_template 'migration.rb.erb', "db/migrate/create_#{@table_name}.rb"
        end

        def create_upload_controller
          template 'slider_upload_controller.rb.erb', "app/controllers/admin/#{@class_name.pluralize.underscore}_controller.rb"

          sentinel = /namespace :admin do\s*$/
          routing_code = "  resource :#{@class_name.underscore}, only: :create, as: :upload_#{@class_name.underscore}"
          in_root do
            inject_into_file 'config/routes.rb', "\n  #{routing_code}", {:after => sentinel, :verbose => false}
          end
        end

      end
    end
  end
end

