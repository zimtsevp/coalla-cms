require 'rails/generators/active_record'

module Coalla
  module Cms

    class CreateAdminLoginViewGenerator < ActiveRecord::Generators::Base
      argument :name, type: :string, default: ""
      source_root File.expand_path("../templates", __FILE__)

      def setup_directory
        empty_directory 'app/views/administrators/sessions'
        empty_directory 'app/controllers/admin'

        template 'controllers/admin/base_controller.rb.erb', 'app/controllers/admin/base_controller.rb'
        template 'controllers/admin/home_controller.rb.erb', 'app/controllers/admin/home_controller.rb'
        template 'views/administrators/sessions/new.html.haml', 'app/views/administrators/sessions/new.html.haml'
      end

    end
  end
end


