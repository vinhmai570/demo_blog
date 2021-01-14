class MicropostsController < ApplicationController
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:notice] = 'Micropost created!'
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:notice] = 'Micropost deleted'
    redirect_to request.referrer || root_url
  end

  private

  def logged_in_user
    return if logged_in?

    store_location
    flash[:notice] = 'Please login'
    redirect_to login_url
  end

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find(params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
