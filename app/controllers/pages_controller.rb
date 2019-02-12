class PagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost = current_user.microposts.build
    @feed_items = current_user.feed.order_desc.page(params[:page])
      .per Settings.micropost_per_page

  end

  def help; end
end
