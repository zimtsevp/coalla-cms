class FileUpload < ActiveRecord::Base

  mount_uploader :file, FileUploader

  before_save :update_file_attributes

  validates_presence_of :file, unless: :file_cache

  private

  def update_file_attributes
    if file.present? && file_changed?
      self.content_type = file.file.content_type
      self.file_size = file.file.size
      self.file_name = file.file.filename if self.respond_to? :file_name=
    end
  end

end