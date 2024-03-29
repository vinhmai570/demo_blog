class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        flash[:notice] = 'Login was successful'
        redirect_back_or user
      else
        message = 'Account not activated.'
        message += 'Check your email for the activation link.'
        flash[:notice] = message
        redirect_to root_url
      end
    else
      flash[:notice] = 'Login was failed.'
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
