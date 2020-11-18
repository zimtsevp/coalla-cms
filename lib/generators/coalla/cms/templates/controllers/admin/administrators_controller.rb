module Admin

  class AdministratorsController < BaseController

    PER_PAGE = 20

    def index
      @administrators = Administrator.order(created_at: :desc).paginate(page: params[:page], per_page: PER_PAGE)
    end

    def new
      @administrator = Administrator.new
    end

    def create
      @administrator = Administrator.new(params[:administrator].permit!)
      if @administrator.save
        redirect_or_render :edit
      else
        render :new
      end
    end

    def edit
      @administrator = Administrator.find(params[:id])
    end

    def update
      @administrator = Administrator.find(params[:id])
      success = administrator_params[:password].present? ? @administrator.update(administrator_params) : @administrator.update_without_password(administrator_params)
      if current_administrator == @administrator
        sign_in(@administrator, bypass: true)
      end
      if success
        redirect_or_render :edit
      else
        render :edit
      end
    end

    def destroy
      @administrator = Administrator.find(params[:id])
      @administrator.destroy
      redirect_to_last
    end

    private

    def administrator_params
      params[:administrator].permit!
    end

  end

end