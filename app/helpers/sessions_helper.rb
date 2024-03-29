module SessionsHelper
  # Logs in the given user
  def log_in(user)
    session[:user_email] = user.email
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_email] = user.email
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    if (user_email = session[:user_email])
      @current_user ||= User.find_by(email: session[:user_email])
    elsif (user_email = cookies.signed[:user_email]) 
      user = User.find_by(email: user_email)
      if user&.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def current_user?(user)
    user && user == current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_email)
    cookies.delete(:user_email)
    cookies.delete(:remember_token)
    @current_user = nil
  end

  # Forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_email)
    cookies.delete(:remember_token)
  end

  # Redirects to stored location (or to the default). def redirect_back_or(default)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end