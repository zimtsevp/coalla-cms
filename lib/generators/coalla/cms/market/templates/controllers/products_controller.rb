module Admin

  class Market::ProductsController < BaseController

    handle_return_path

    PER_PAGE = 20

    def index
      @products = ::Market::Product.order(created_at: :desc).paginate(page: params[:page], per_page: PER_PAGE)
    end

    def new
      @product = ::Market::Product.new
    end

    def create
      @product = ::Market::Product.new(params[:market_product].permit!)
      if @product.save
        redirect_to_back
      else
        render :new
      end
    end

    def edit
      @product = ::Market::Product.find(params[:id])
    end

    def update
      @product = ::Market::Product.find(params[:id])
      if @product.update_attributes(params[:market_product].permit!)
        redirect_to_back
      else
        render :edit
      end
    end

    def destroy
      @product = ::Market::Product.find(params[:id])
      @product.destroy
      redirect_to_back
    end

    private


  end

end