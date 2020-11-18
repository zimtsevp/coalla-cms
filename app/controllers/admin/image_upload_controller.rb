module Admin

  class ImageUploadController < BaseController

    def upload_image
      @image = params[:image_class].camelize.constantize.new
      @image.send("#{params[:field]}=", params[:image])
      @image.valid?
      @free_size = params[:free_size] || false

      @errors = @image.errors[params[:field].to_sym]
      if @errors.blank?
        @preview_url = if params[:version].present?
                         @image.send("#{params[:field]}_url", params[:version].to_sym)
                       else
                         @image.send("#{params[:field]}_url")
                       end
        @image_cache = @image.send("#{params[:field]}_cache")
        render '/admin/common/upload_image'
      else
        render '/admin/common/upload_failed'
      end
    end

  end

end