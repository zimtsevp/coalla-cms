module Admin

  class AutocompleteController < BaseController

    def list
      model_class = params[:model].camelize.constantize
      field_name = params[:field].to_sym
      entities = model_class.where("#{field_name} ilike ?", "%#{params[:q]}%").order(field_name)
      render :json => entities.map {|e| {:id => e.id, :name => e.send(field_name)}}
    end

  end

end