class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by_email(params[:email])

    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:notice] = 'Account activated!'
    end
    # flash[:notice] = params[:id]
    redirect_to root_path
  end
end
