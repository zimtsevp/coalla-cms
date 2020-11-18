class Market::Category < ActiveRecord::Base

  has_many :subcategories, inverse_of: :category, dependent: :destroy, class_name: '::Market::Category'
  belongs_to :category, inverse_of: :subcategories, class_name: '::Market::Category'

  validates :name, presence: true

  scope :ordered, -> { order(:position) }
  scope :top_level, -> { ordered.where(category_id: nil) }

  def full_name
    categories = [self]
    category = self
    while category.category
      category = category.category
      categories << category
    end
    categories.reverse.map(&:name).join(' -> ')
  end

  def self.for_combo(category)
    parents = top_level
    parents = parents.where.not(id: category.id) if category
    result = []
    parents.each do |top_level|
      result << top_level
      result << top_level.ordered_subcategories.order(:position).reject { |sub_category| sub_category == category }
    end
    result.flatten
  end

  def ordered_subcategories
    subcategories.ordered
  end

end
