class StaticPagesController < ApplicationController
  def home
    @micropost = current_user.microposts.build if logged_in?
    @user = current_user
    @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def help
  end

  def about
  end
end
