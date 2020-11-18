class CreateFileUpload < ActiveRecord::Migration

  def change
    create_table(:file_uploads) do |t|
      t.text :file, null: false
      t.text :file_name
      t.text :content_type
      t.integer :file_size, null: false, default: 0
      t.timestamps
    end

    add_index :file_uploads, :file
    add_index :file_uploads, :content_type
    add_index :file_uploads, :file_size
  end

end