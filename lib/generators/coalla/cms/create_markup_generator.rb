require 'rails/generators/active_record'

module Coalla
  module Cms

    class CreateMarkupGenerator < ActiveRecord::Generators::Base
      argument :name, type: :string, default: ""
      source_root File.expand_path('../templates', __FILE__)

      def copy_controller_file
        template 'controllers/markup_controller.rb.erb', 'app/controllers/markup_controller.rb'
        empty_directory 'app/views/markup'
      end

      def setup_routes
        sentinel = /namespace :admin do\s*$/

        routing_code = <<EOF
  scope controller: :markup, as: :markup, path: 'markup' do
    get :lot
  end
EOF

        in_root do
          inject_into_file 'config/routes.rb', "\n  #{routing_code}", {after: sentinel}
        end
      end
    end
  end
end