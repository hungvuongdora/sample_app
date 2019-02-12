class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: %i(destroy)

  def create
    @micropost = current_user.microposts.build micropost_params

    if @micropost.save
      flash[:success] = t ".success"
      redirect_to root_url
    else
      @feed_items = current_user.microposts.order_desc.page(params[:page])
        .per Settings.micropost_per_page
      render "pages/home"
    end
  end

  def destroy
    @micropost.destroy ? flash[:success] = t(".success") : flash[:danger] = t(".danger")
    redirect_to request.referrer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]

    return if @micropost
    flash[:danger] = t ".fail"
    redirect_to root_url
  end
end
