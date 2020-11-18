#encoding: utf-8
require 'rails'
require 'rails/generators/active_record'

module Coalla
  module Cms
    module Market

      class InstallGenerator < ::ActiveRecord::Generators::Base
        argument :name, type: :string, default: ''
        source_root File.expand_path('../templates', __FILE__)

        def copy_root_module
          copy_file 'market.rb', 'app/models/market.rb'
        end

        def copy_models
          directory 'models', 'app/models/market'
        end

        def create_migrations
          migration_template "migrations/create_categories.rb", "db/migrate/create_categories.rb"
          migration_template "migrations/create_properties.rb", "db/migrate/create_properties.rb"
          migration_template "migrations/create_products.rb", "db/migrate/create_products.rb"
          migration_template "migrations/create_product_properties.rb", "db/migrate/create_product_properties.rb"
        end

        def setup_routes
          sentinel = /namespace :admin do\s*$/

          routing_code = <<-INSERT
  namespace :market do
      resources :categories
      resources :properties
      resources :products
    end
          INSERT
          in_root do
            inject_into_file 'config/routes.rb', "\n  #{routing_code}", {after: sentinel, verbose: false}
          end
        end

        def setup_dashboard
          append_to_file 'config/structure.rb', <<-INSERT
separator I18n.t('dashboard.market')
section Market::Category, description: I18n.t('dashboard.category.description'), icon: 'glyphicon glyphicon-folder-open'
section Market::Property, description: I18n.t('dashboard.property.description'), icon: 'glyphicon glyphicon-th-list'
section Market::Product, description: I18n.t('dashboard.product.description'), icon: 'glyphicon glyphicon-shopping-cart'
          INSERT
        end

        def copy_views
          directory 'views', 'app/views/admin/market'
        end

        def copy_controllers
          directory 'controllers', 'app/controllers/admin/market'
        end

        def copy_localization
          copy_file 'market.ru.yml', 'config/locales/market.ru.yml'
        end

        def install_slider
          generate 'coalla:cms:slider:init'
        end

      end
    end
  end
end
