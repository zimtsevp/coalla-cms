module Admin

  class SiteMetaTagsController < BaseController
    before_action :set_meta_tags, only: [:edit, :update, :destroy]

    def index
      @meta_tags = SiteMetaTags.order(:created_at)
    end

    def new
      @meta_tags = SiteMetaTags.new
    end

    def create
      @meta_tags = SiteMetaTags.new(params[:site_meta_tags].permit!)
      if @meta_tags.save
        redirect_to admin_meta_tags_path
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @meta_tags.update_attributes(params[:site_meta_tags].permit!)
        redirect_to admin_meta_tags_path
      else
        render :edit
      end
    end

    def destroy
      @meta_tags.destroy
      redirect_to admin_meta_tags_path
    end

    private
    
    def set_meta_tags
      @meta_tags = SiteMetaTags.find(params[:id])
    end

  end

end