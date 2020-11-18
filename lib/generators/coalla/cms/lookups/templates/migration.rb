class CreateLookups < ActiveRecord::Migration
  def change
    create_table(:lookups) do |t|
      t.text :code, null: false
      t.text :value
      t.text :type_code, null: false
      t.text :value_options
      t.text :tooltip
      t.text :category
      t.text :file
      t.timestamps
    end

    add_index :lookups, :code, unique: true
    add_index :lookups, :type_code
  end
end