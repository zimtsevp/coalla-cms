class CreateProducts < ActiveRecord::Migration

  def change
    create_table :market_products do |t|
      t.text :name, null: false
      t.index :name
      t.decimal :price, null: false
      t.index :price
      t.text :sku, null: false
      t.references :category
      t.index :category_id
      t.foreign_key :market_categories, column: :category_id
      t.timestamps
      t.text :description
    end
  end

end
