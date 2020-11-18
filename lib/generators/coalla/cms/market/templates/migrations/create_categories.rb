class CreateCategories < ActiveRecord::Migration

  def change
    create_table(:market_categories) do |t|
      t.text :name, null: false
      t.integer :position, default: 0
      t.index :position
      t.references :category
      t.foreign_key :market_categories, column: :category_id
      t.index :category_id
      t.timestamps
    end
  end

end