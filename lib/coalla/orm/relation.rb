module Coalla

  module Relation

    def multi_field(relation_name, options = {})
      through_collection_name = options[:through_collection_name] || "#{self.model_name.singular}_#{relation_name}".to_sym
      reflection = self.reflections[through_collection_name] || self.reflections[through_collection_name.to_s]
      through_class = reflection.klass
      self_foreign_key = reflection.foreign_key

      reflection = self.reflections[relation_name] || self.reflections[relation_name.to_s]
      association_model_name = reflection.source_reflection_name.to_sym
      association_foreign_key = reflection.foreign_key

      tokens_attribute_name = "#{relation_name}_tokens"
      attr_reader tokens_attribute_name

      define_method "#{tokens_attribute_name}=" do |ids|
        new_through_collection = ids.split(',').each_with_index.map do |id, position|
          through_class.new(self_foreign_key => self.id, association_foreign_key => id, position: position)
        end
        self.send("#{through_collection_name}=", new_through_collection)
      end

      define_method "#{relation_name}_json" do |search_field|
        send(through_collection_name).map { |c| {id: c.send(association_model_name).id, name: c.send(association_model_name).send(search_field)} }
      end

    end

  end

end

ActiveRecord::Base.extend Coalla::Relation