module SessionsHelper

  # Logs in the given user
  def log_in(user)
    session[:user_email] = user.email
  end

  def current_user
    if session[:user_email]
      @current_user ||= User.find_by(email: session[:user_email])
    end
  end

  def logged_in? 
    !current_user.nil?
  end

  def log_out
    session.delete(:user_email)
    @current_user = nil
  end

end
