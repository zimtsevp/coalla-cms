module PageMetaTags
  extend ActiveSupport::Concern

  included do
    helper_method :current_url


    def set_page_meta_tags(options={})
      id = options.delete(:identifier)

      tags = {
          site: tag_value(:site, id),
          title: title_for(tag_value(:title, id)),
          description: tag_value(:description, id),
          image: tag_value(:image, id),
          url: tag_value(:url, id) || current_url,

          og: {
              title: title_for(tag_value(:title, id, true)).last || defaults.site,
              description: tag_value(:description, id, true),
              image: tag_value(:image, id, true),
              url: tag_value(:url, id, true) || current_url,
          }
      }

      tags.deep_merge!(options)

      set_meta_tags(tags)
    end

    private

    def tag_value(tag_name, identifier, og = false)
      variants = []

      og_tag_name = "og_#{tag_name}".to_sym if og

      variants << page_tags(identifier).send(:try, og_tag_name) if og
      variants << page_tags(identifier).send(:try, tag_name)
      variants << defaults.send(:try, og_tag_name) if og
      variants << defaults.send(:try, tag_name)

      if tag_name == :image
        variants = variants.map { |v| URI.join(view_context.root_url, v.try(:url, :main)).to_s if v.try(:url, :main).present? }
      end

      result = variants.detect(&:present?)
      return if result.blank?
      result.html_safe
    end

    def title_for(title)
      [title].flatten
    end

    def current_url
      request.original_url
    end

    def defaults
      @default_tags ||= SiteMetaTags.default_tags
    end

    def page_tags(identifier)
      return if identifier.blank?

      @page_tags ||= {}
      @page_tags[identifier] ||= SiteMetaTags.find_by(identifier: identifier)
    end
  end
end