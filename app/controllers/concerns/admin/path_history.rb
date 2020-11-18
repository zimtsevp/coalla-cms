module Admin::PathHistory

  # To ensure correct path history working we need to be 100% sure that browser's back button will not use cache
  def no_cache!
    response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end

  # Stores history of GET-request urls. We don't need to store POST or any other requests
  # because we can't use them for creating back buttons or redirection.
  def store_path_history
    if !request.xhr? && request.method == 'GET' && session[:last_path] != request.fullpath
      session[:prev_path] = session[:last_path]
      session[:last_path] = request.fullpath
    end
  end

  # Returns url of previous GET-request. Used for 'cancel' button.
  def back_uri
    session[:prev_path] || '/admin'
  end

  # Returns url of last GET-request. Used in #redirect_to_last method for redirection
  # after clicking 'destroy' button on index pages. This is useful for pagination
  # because client will be redirected on the same page he was.
  def last_uri
    session[:last_path]
  end

  def redirect_to_back
    redirect_to back_uri
  end

  def redirect_to_last
    redirect_to last_uri
  end

end
