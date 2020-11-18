class CreateProductProperties < ActiveRecord::Migration

  def change
    create_table :market_product_properties do |t|
      t.text :value
      t.references :product
      t.index :product_id
      t.foreign_key :market_products, column: :product_id

      t.references :property
      t.index :property_id
      t.foreign_key :market_properties, column: :property_id

      t.timestamps
    end
  end

end
