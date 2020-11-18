module Admin

  module SortableController

    def sort
      self.instance_variable_set("@#{controller_name}", model_name.ordered)
    end

    def apply_sort
      ActiveRecord::Base.connection.transaction do
        params[controller_name].keys.each_with_index do |id, idx|
          model_name.find(id).update_attribute(:position, idx)
        end
      end
      redirect_to action: :index
    end

    private

    def model_name
      controller_name.classify.constantize
    end

  end

end