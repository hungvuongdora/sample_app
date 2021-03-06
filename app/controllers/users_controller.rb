class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :find_user, only: %i(edit show destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @user = User.page(params[:page]).per Settings.user_controller.value_item
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash.now[:success] = t ".flash"
      redirect_to @user
    else
      flash.now[:danger] = t ".danger"
      render :new
    end
  end

  def show
    @microposts = @user.microposts.order_desc.page(params[:page])
                    .per Settings.micropost_per_page
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".success"
      redirect_to @user
    else
      flash.now[:danger] = t ".danger"
      render :edit
    end
  end

  def destroy
    if @user&.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t".danger"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".danger"
    redirect_to login_url
  end

  def find_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t ".danger"
    redirect_to signup_path
  end

  def correct_user
    redirect_to root_url unless current_user.current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
