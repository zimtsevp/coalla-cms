module Admin
  module LookupHelper
    def tooltip_lookup_data(lookup)
      if lookup.try(:tooltip).present?
        {toggle: 'tooltip', placement: 'top', title: lookup.tooltip}
      else
        {}
      end
    end

    def format_lookup(lookup)
      if %w(string memo wysiwyg integer float).include?(lookup.type_code)
        raw(truncate(strip_tags(lookup.value), length: 200))
      elsif lookup.type_code == 'boolean'
        lookup.value == '1' ? '<i class="glyphicon glyphicon-check"></i>'.html_safe : ''
      elsif lookup.type_code == 'file'
        lookup.file.try(:file).try(:filename) || ''
      elsif lookup.type_code == 'enum'
        enum_lookup_text(lookup.code)
      end
    end
  end
end