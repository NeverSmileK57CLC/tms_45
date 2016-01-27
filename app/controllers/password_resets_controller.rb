class PasswordResetsController < ApplicationController
  before_action :load_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      @user.save
      flash[:success] = t "notice.email.sent_password"
      redirect_to root_path
    else
      flash.now[:warning] = t "notice.email.not_found"
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      log_in @user
      flash[:success] = t "notice.email.password_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    unless @user && @user.authenticated?(:reset, params[:id])
      flash[:alert] = t "notice.email.not_valid_user"
      redirect_to root_path
    end
  end

  def check_expiration
    if @user.password_reset_expired? Settings.email.time_expired
      flash[:notice] = t "notice.email.reset_expired"
      redirect_to new_password_reset_url
    end
  end
end
