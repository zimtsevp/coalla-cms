module Admin

  class LookupsController < BaseController
    before_action :set_lookup, only: [:show, :edit, :update, :destroy]

    def index
      @category = params[:category]
      @lookups = Lookup.where(category: @category).order(:code, :created_at)
      if @lookups.blank? && @category.present?
        redirect_to admin_lookups_index_path
        return
      end
    end

    def new
      @lookup = Lookup.new
    end

    def create
      @lookup = Lookup.new(params[:lookup])
      if @lookup.save
        redirect_to admin_lookups_index_path(category: @lookup.category)
      else
        render :new
      end
    end

    def show
    end

    def edit
    end

    def update
      if @lookup.update_attributes(params[:lookup].permit!)
        redirect_to admin_lookups_index_path(category: @lookup.category)
      else
        render :edit
      end
    end

    def destroy
      @lookup.destroy
      redirect_to admin_lookups_index_path(category: @lookup.category)
    end

    private
    
    def set_lookup
      @lookup = Lookup.find(params[:id])
    end

  end

end