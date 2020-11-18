module Coalla
  module Cms
    class Engine < ::Rails::Engine
      require 'active_support/i18n'
      I18n.load_path += Dir[File.expand_path('../../../config/locales/*.yml', __FILE__)]

      initializer :init_slider do
        ActiveSupport.on_load :active_record do
          require 'coalla/orm/page_slider'
          require 'coalla/orm/relation'
          require 'coalla/orm/sanitized'
        end
      end
    end
  end
end