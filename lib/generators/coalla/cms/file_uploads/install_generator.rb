require 'rails'
require 'rails/generators/active_record'

module Coalla
  module Cms
    module FileUploads

      class InstallGenerator < ActiveRecord::Generators::Base
        argument :name, type: :string, default: ""
        source_root File.expand_path("../templates", __FILE__)
        class_option :copy, type: :boolean, default: false, description: "Copy all files to project"

        def copy_files
          migration_template "migration.rb", "db/migrate/create_file_upload.rb"

          #if options.copy?
          #  [ 'app/views/admin/lookups/_form.html.haml',
          #    'app/views/admin/lookups/edit.html.haml',
          #    'app/views/admin/lookups/index.html.haml',
          #    'app/views/admin/lookups/new.html.haml',
          #    'app/views/admin/lookups/show.html.haml',
          #    'app/controllers/admin/lookups_controller.rb',
          #    'app/models/lookup.rb',
          #    'app/helpers/lookup_helper.rb'
          #  ].each do |path|
          #    copy_file path, path
          #  end
          #end
        end

      end

    end
  end
end
