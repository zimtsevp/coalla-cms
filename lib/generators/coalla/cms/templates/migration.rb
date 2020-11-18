class Create<%= table_name.camelize %>Model < ActiveRecord::Migration
  def change
    create_table(:<%= table_name %>) do |t|
<%= migration_data -%>
      t.timestamps
    end
    add_index :<%= table_name %>, :email, unique: true

<%= create_default_admin %>
  end
end
