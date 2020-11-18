require 'rails/generators/active_record'

module Coalla
  module Cms

    class CreateAdminAdministratorsGenerator < ActiveRecord::Generators::Base
      argument :name, type: :string, default: ""
      source_root File.expand_path("../templates", __FILE__)

      def setup_directory
        copy_file 'controllers/admin/administrators_controller.rb', 'app/controllers/admin/administrators_controller.rb'
        directory 'views/admin/administrators', 'app/views/admin/administrators'
        inject_into_file 'config/structure.rb', "section Administrator, description: I18n.t('activerecord.structure.administrator'), icon: 'glyphicon glyphicon-home'", before: /^/
      end

      def setup_routes
        sentinel = /namespace :admin do\s*$/

        routing_code = "  resources :administrators"
        in_root do
          inject_into_file 'config/routes.rb', "\n  #{routing_code}", {after: sentinel}
        end
      end

    end
  end
end


