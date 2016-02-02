class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :load_user, only: [:show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def show
    @user_courses = UserCourse.joined_as_trainee @user
    @user_subjects = UserSubject.all
    @user_tasks = UserTask.all
    @activities = @user.activities.paginate page: params[:page]
  end

  def new
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t :profile_updated
      redirect_to root_url
    else
      render :edit
    end
  end

  private
  def load_user
    @user = User.find_by id: params[:id]
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end
end
