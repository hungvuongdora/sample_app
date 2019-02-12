class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user&.authenticate(params[:session][:password])
      set_cookie_sessions user
    else
      flash.now[:danger] = t ".danger"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def set_cookie_sessions user
    if user.activated?
      log_in user

      if params[:session][:remember_me] == Settings.remember
        remember user
      else
        forget user
      end
      redirect_back_or user
    else
      flash[:danger] = t ".danger_create"
      redirect_to root_url
    end
  end
end
