module NestedFieldsHelper

  def link_to_add_fields(name, builder, association)
    new_object = builder.object.send(association).klass.new
    id = new_object.object_id
    fields = builder.fields_for(association, new_object, child_index: id) do |builder|
      render 'admin/common/nested_fields_for_element',  builder: builder, partial: "#{association.to_s.singularize}_fields"
    end
    link_to(name, '#', class: 'add_fields btn btn-success', data: {id: id, fields: fields.gsub("\n", '')})
  end

end