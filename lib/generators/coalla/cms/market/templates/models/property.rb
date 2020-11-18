class Market::Property < ActiveRecord::Base

  has_many :product_properties, dependent: :destroy, inverse_of: :property, class_name: '::Market::ProductProperty'
  has_many :products, through: :product_properties

  validates :name, presence: true
end
