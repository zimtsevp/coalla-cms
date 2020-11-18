class Lookup < ActiveRecord::Base

  validates_presence_of :code
  validates_uniqueness_of :code
  validates_numericality_of :value, only_integer: true, if: ->(lookup) { lookup.type_code == 'integer' }
  validates_numericality_of :value, if: ->(lookup) { lookup.type_code == 'float' }

  mount_uploader :file, FileUploader

  def value_options
    attr_value = read_attribute(:value_options)

    if attr_value.present?
      ActiveSupport::JSON.decode(attr_value).with_indifferent_access
    else
      {}
    end
  end

  def value_options=(value)
    write_attribute(:value_options, ActiveSupport::JSON.encode(value).to_s) if value.present?
  end

  def select_options
    value_options.map { |key, value| [value, key] }
  end

end