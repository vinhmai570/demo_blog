class PasswordResetsController < ApplicationController
  before_action :get_user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new
  end

  def create
    @user = User.find_by_email(params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:notice] = 'Email sent with password reset intructions'
      redirect_to root_url
    else
      flash.now[:notice] = 'Email address not found'
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "Can't be empty")
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:notice] = 'Password has been reset.'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by_email(params[:email])
  end

  # confirm a valid user.
  def valid_user
    redirect_to root_url unless @user&.activated && @user.authenticated?(:reset, params[:id])
    # flash[:notice] = @user
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:notice] = 'Password reset has expired.'
    redirect_to new_password_reset_url
  end
end
