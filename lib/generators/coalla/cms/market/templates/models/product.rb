class Market::Product < ActiveRecord::Base

  has_many :product_properties, dependent: :destroy, inverse_of: :product
  has_many :properties, through: :product_properties

  slider :images

  belongs_to :category

  accepts_nested_attributes_for :product_properties, allow_destroy: true

  validates :name, presence: true
  validates :price, presence: true
  validates :sku, presence: true

end