module Admin

  class Market::PropertiesController < BaseController

    handle_return_path

    PER_PAGE = 20

    def index
      if params[:term].present?
        # autocomplete
        render json: ::Market::Property.where('name ILIKE ?', "#{params[:term]}%").order(:name).map { |property| {id: property.id, label: property.name} }
      else
        @properties = ::Market::Property.order(:name).paginate(page: params[:page], per_page: PER_PAGE)
      end
    end

    def new
      @property = ::Market::Property.new
    end

    def create
      property_params
      @property = ::Market::Property.new(property_params)
      if @property.save
        redirect_to_back
      else
        render :new
      end
    end

    def edit
      @property = ::Market::Property.find(params[:id])
    end

    def update
      @property = ::Market::Property.find(params[:id])
      if @property.update_attributes(property_params)
        redirect_to_back
      else
        render :edit
      end
    end

    def destroy
      @property = ::Market::Property.find(params[:id])
      @property.destroy
      redirect_to_back
    end

    private

    def property_params
      params[:market_property].permit(:name)
    end

  end

end