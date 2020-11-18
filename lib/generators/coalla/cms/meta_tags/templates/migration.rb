class CreateMetaTags < ActiveRecord::Migration
  def change
    create_table :meta_tags do |t|
      t.text :identifier, null: false
      t.index :identifier, unique: true

      t.text :site, null: false, default: ''
      t.text :title, null: false, default: ''
      t.text :description, null: false, default: ''
      t.text :image
      t.text :url

      t.text :og_title
      t.text :og_description
      t.text :og_image
      t.text :og_url

      t.timestamps
    end

    SiteMetaTags.create!(identifier: :default)
  end
end