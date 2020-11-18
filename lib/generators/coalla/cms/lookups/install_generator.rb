require 'rails'
require 'rails/generators/active_record'

module Coalla
  module Cms
    module Lookups

      class InstallGenerator < ActiveRecord::Generators::Base
        argument :name, type: :string, default: ''
        source_root File.expand_path('../../../../../../', __FILE__)
        class_option :copy, type: :boolean, default: false, description: 'Copy all files to project'

        def copy_files
          migration_template 'lib/generators/coalla/cms/lookups/templates/migration.rb', 'db/migrate/create_lookups.rb'

          if options.copy?
            [ 'app/views/admin/lookups/types/boolean',
              'app/views/admin/lookups/types/enum',
              'app/views/admin/lookups/types/float',
              'app/views/admin/lookups/types/integer',
              'app/views/admin/lookups/types/memo',
              'app/views/admin/lookups/types/string',
              'app/views/admin/lookups/types/wysiwyg',
              'app/views/admin/lookups/_form.html.haml',
              'app/views/admin/lookups/edit.html.haml',
              'app/views/admin/lookups/index.html.haml',
              'app/views/admin/lookups/show.html.haml',
              'app/controllers/admin/lookups_controller.rb',
              'app/models/lookup.rb',
              'app/helpers/lookup_helper.rb'
            ].each do |path|
              copy_file path, path
            end
          end
        end

        def setup_routes
          sentinel = /namespace :admin do\s*$/

          routing_code = "  get 'lookups/(:category)' => 'lookups#index', as: :lookups_index\n  resources :lookups, except: [:show]"
          in_root do
            inject_into_file 'config/routes.rb', "\n  #{routing_code}", { :after => sentinel, :verbose => false }
          end
        end

        def add_section
          append_to_file 'config/structure.rb', "\nlookup_section"
        end

      end

    end
  end
end
