class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t".flash"
      redirect_to @user
    else
      flash[:danger] = t".danger"
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t".danger"
    redirect_to signup_path
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,:password_confirmation
  end
end