class CreateProperties < ActiveRecord::Migration

  def change
    create_table :market_properties do |t|
      t.text :name
      t.index :name
      t.timestamps
    end
  end

end
