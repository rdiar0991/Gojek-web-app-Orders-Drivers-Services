module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    session[:role] = user.class.name.downcase
  end

  def current_user
      @current_user ||= session[:role].classify.constantize.find_by(id: session[:user_id]) unless session[:role].nil?
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    session.delete(:role)
    @current_user = nil
  end

  def current_user?(user)
    user == current_user
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
