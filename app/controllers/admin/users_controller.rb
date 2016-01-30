class Admin::UsersController < Admin::CoursesController
  before_action :load_user, except: [:index, :create, :new]

  def index
    search_user = User.search(params[:search]).order :id
    @users = search_user.paginate page: params[:page]
    @all_users = User.all
    respond_to do |format|
      format.html
      format.csv {send_data @all_users.to_csv}
      format.xls
      format.js
     end
  end

  def show
    @user_courses = UserCourse.joined_by @user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "flash.success.create_user"
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "flash.success.update_user"
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t "flash.success.destroy_user"
    redirect_to admin_users_path
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation, :role
  end

  def load_user
    @user = User.find params[:id]
  end
end
