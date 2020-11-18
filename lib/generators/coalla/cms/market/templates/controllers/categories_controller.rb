module Admin

  class Market::CategoriesController < BaseController

    handle_return_path

    PER_PAGE = 20

    def index
      @categories = ::Market::Category.order('category_id DESC, position').paginate(page: params[:page], per_page: PER_PAGE)
    end

    def new
      @category = ::Market::Category.new
    end

    def create
      @category = ::Market::Category.new(params[:market_category].permit!)
      if @category.save
        redirect_to_back
      else
        render :new
      end
    end

    def edit
      @category = ::Market::Category.find(params[:id])
    end

    def update
      @category = ::Market::Category.find(params[:id])
      if @category.update_attributes(params[:market_category].permit!)
        redirect_to_back
      else
        render :edit
      end
    end

    def destroy
      @category = ::Market::Category.find(params[:id])
      @category.destroy
      redirect_to_back
    end

  end

end