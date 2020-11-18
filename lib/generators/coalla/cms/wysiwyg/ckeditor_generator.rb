require 'rails'

module Coalla
  module Cms
    module Wysiwyg

      class CkeditorGenerator < ::Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)

        def init_ckeditor
          generate 'ckeditor:install', '--orm=active_record --backend=carrierwave'
        end

      end
    end
  end
end
