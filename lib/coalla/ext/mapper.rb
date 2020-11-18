module ActionDispatch::Routing

  class Mapper

    def sortable
      collection do
        get :sort
        post '/sort' => :apply_sort
      end
    end

  end

end