require 'rails'
require 'rails/generators/active_record'

module Coalla
  module Cms
    module MetaTags

      class InstallGenerator < ActiveRecord::Generators::Base
        argument :name, type: :string, default: ''
        source_root File.expand_path('../../../../../../', __FILE__)
        class_option :copy, type: :boolean, default: false, description: 'Copy all files to project'

        def copy_files
          migration_template 'lib/generators/coalla/cms/meta_tags/templates/migration.rb', 'db/migrate/create_meta_tags.rb'

          if options.copy?
            [
                'app/views/admin/site_meta_tags/_form.html.haml',
                'app/views/admin/site_meta_tags/edit.html.haml',
                'app/views/admin/site_meta_tags/index.html.haml',
                'app/controllers/admin/meta_tags_controller.rb',
                'app/controllers/concerns/page_meta_tags.rb',
                'app/uploaders/meta_tags_image_uploader.rb'
            ].each do |path|
              copy_file path, path
            end
          end
        end

        def setup_routes
          sentinel = /namespace :admin do\s*$/

          routing_code = '  resources :meta_tags, except: [:show], controller: :site_meta_tags'
          in_root do
            inject_into_file 'config/routes.rb', "\n  #{routing_code}", {:after => sentinel, :verbose => false}
          end
        end

        def add_module_to_application_controller
          gsub_file 'app/controllers/application_controller.rb', /protect_from_forgery with: :exception/ do |match|
            c = <<-RUBY

  include PageMetaTags

            RUBY
            match << c
          end

        end

        def add_section
          append_to_file 'config/structure.rb', "\nmeta_tags_section"
        end

      end
    end
  end
end