class Market::ProductProperty < ActiveRecord::Base

  belongs_to :product, class_name: '::Market::Product', inverse_of: :product_properties
  belongs_to :property, class_name: '::Market::Property', inverse_of: :product_properties

  def property_name
    property.try(:name)
  end

  def property_name=(name)
    #  no-op
  end

end
