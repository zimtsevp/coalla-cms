module LookupHelper

  def lookup(code, default = nil, &block)
    _lookup(code, 'string', default, &block)
  end

  def integer_lookup(code, default = nil, &block)
    _lookup(code, 'integer', default, &block).to_i
  end

  def float_lookup(code, default = nil, &block)
    _lookup(code, 'float', default, &block).to_f
  end

  def boolean_lookup(code, default = nil, &block)
    _lookup(code, 'boolean', default, &block) == '1'
  end

  def enum_lookup_value(code, default = nil, &block)
    _lookup(code, 'enum', default, &block).to_sym
  end

  def file_lookup(code)
    Lookup.find_by(code: code, type_code: 'file')
  end

  def enum_lookup_text(code)
    value = enum_lookup_value(code)
    return if value.blank?
    l = Lookup.where(code: code, type_code: 'enum').first
    l.value_options[value]
  end

  def memo_lookup(code, default = nil, &block)
    sf(unsafe_memo_lookup(code, default, &block))
  end

  def unsafe_memo_lookup(code, default = nil, &block)
    _lookup(code, 'memo', default, &block)
  end

  def wysiwyg_lookup(code, default = nil, &block)
    raw(_lookup(code, 'wysiwyg', default, &block))
  end

  def lookup_name(code)
    t("lookups.#{code}")
  end

  def sf(text)
    h(text).gsub("\n", "<br/>").html_safe
  end

  private

  def _lookup(code, type, default, &block)
    l = Lookup.where(code: code, type_code: type).first
    return l.value if l

    value = if block.present?
              capture(self, &block)
            else
              default
            end
    value = value.strip if value

    l = Lookup.create!(code: code, value: value, type_code: type)

    l.reload.value
  end

end