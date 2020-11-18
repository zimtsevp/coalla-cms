module Coalla

  module Sanitized

    def sanitize_html(attribute, config = Sanitize::Config::DEFAULT)
      before_save do
        sanitize_attr = Sanitize.fragment(send(attribute), config)
        send("#{attribute}=", sanitize_attr)
      end
    end

  end

end

ActiveRecord::Base.extend Coalla::Sanitized