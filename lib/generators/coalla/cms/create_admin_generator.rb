require 'rails/generators/active_record'
require 'generators/coalla/cms/orm_helpers'

module Coalla
  module Cms
    class CreateAdminGenerator < ActiveRecord::Generators::Base
      argument :name, :type => :string, :default => "Administrator"

      include Coalla::Cms::OrmHelpers
      source_root File.expand_path("../templates", __FILE__)

      def copy_devise_migration
        if (behavior == :invoke && model_exists?) || (behavior == :revoke && migration_exists?(table_name))
          migration_template "migration_existing.rb", "db/migrate/add_admin_role_to_#{table_name}.rb"
        else
          migration_template "migration.rb", "db/migrate/create_#{table_name}_model.rb"
        end
      end

      def generate_model
        unless model_exists? && behavior == :invoke
          invoke "active_record:model", [name],
                 migration: false,
                 fixture: false,
                 test_framework: false
        end
      end

      def inject_devise_content
        inject_into_class(model_path, class_name, model_contents) if model_exists?
      end

      def migration_data
<<RUBY
      t.text :email,              null: false, default: ""
      t.text :encrypted_password, null: false, default: ""

      t.datetime :remember_created_at
RUBY
      end

      def create_default_admin
<<RUBY
    #{table_name.singularize.camelize}.create!(email: 'admin@example.ru', password: '9ijn8uhb')
RUBY
      end

    end
  end
end
