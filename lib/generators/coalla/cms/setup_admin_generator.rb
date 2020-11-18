require 'rails/generators/active_record'

module Coalla
  module Cms

    class SetupAdminGenerator < ActiveRecord::Generators::Base
      argument :name, :type => :string, :default => ""
      source_root File.expand_path("../templates", __FILE__)

      def setup_directory
        invoke "coalla:cms:create_admin"
        invoke "coalla:cms:setup_routes"
        invoke "coalla:cms:create_admin_login_view"
      end

      def copy_structure
        copy_file 'structure.rb', 'config/structure.rb'
      end

      def copy_localization
        copy_file 'locales/admin.ru.yml', 'config/locales/admin.ru.yml'
        copy_file 'locales/admin.en.yml', 'config/locales/admin.en.yml'
      end

      def setup_default_views
        invoke "coalla:cms:create_admin_administrators"
      end

      def patch_application_controller
        gsub_file 'app/controllers/application_controller.rb', /protect_from_forgery with: :exception/ do |match|
          c = <<-RUBY

  layout :layout_by_resource

  def layout_by_resource
    if devise_controller? && resource_name === :administrator
      'admin'
    else
      'application'
    end
  end

  def after_sign_in_path_for resource
    case resource
      when Administrator
        admin_dashboard_path
      else
        root_path
    end
  end
          RUBY
          match << c
        end
      end


      def install_ckeditor
        generate 'coalla:cms:wysiwyg:ckeditor'
      end

    end
  end
end
