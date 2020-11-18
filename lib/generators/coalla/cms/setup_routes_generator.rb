require 'rails/generators/active_record'
#require 'generators/coalla/cms/orm_helpers'

module Coalla
  module Cms
    class SetupRoutesGenerator < ActiveRecord::Generators::Base
      argument :name, :type => :string, :default => "administrator"

      def create_route
        route "devise_for :#{name.pluralize}
  devise_scope :#{name} do
    get '/admin' => 'devise/sessions#new'
  end
  namespace :admin do
    scope controller: :image_upload do
      post 'uploads/:image_class/:field' => :upload_image, as: 'upload_image'
    end
    scope controller: :home do
      get :dashboard
    end
    scope controller: :autocomplete do
      get 'list/:model/:field' => :list, as: 'autocomplete'
    end
    get 'notifier/test_sending' => 'notifier#test_sending'
  end"
      end
    end
  end
end
