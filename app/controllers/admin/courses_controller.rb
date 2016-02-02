class Admin::CoursesController < Admin::AdminController
  before_action :load_course, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_admin, only: [:edit, :update, :show]
  before_action only: [:edit, :update, :show] do
    verify_admin_or_supervisor @course
  end

  def index
    search_course = Course.search(params[:search]).order :id
    @courses = search_course.paginate page: params[:page]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @course = Course.new
    @course.build_subject_courses
  end

  def create
    @course = Course.new course_params
    @course.user_id = current_user.id
    if @course.save
      flash[:success] = t "admin.flash.create_course"
      redirect_to admin_course_path @course
    else
      @course.build_subject_courses
      render :new
    end
  end

  def edit
    @course.build_subject_courses @course.subjects
  end

  def update
    @course.user_id = current_user.id
    if params[:type]
      @course.update_attributes status: params[:type].to_i
      redirect_to :back
    else
      if @course.update_attributes course_params
        flash[:success] = t "admin.flash.edit_course"
        redirect_to admin_course_path @course
      else
        render :edit
      end
    end
  end

  def show
    @subject_courses = SubjectCourse.all
    @activities = Activity.get_activities current_user.id,
      Settings.target_type.update_course, @course.id
  end

  def destroy
    if @course.destroy
      flash[:success] = t "admin.courses.delete_success"
    else
      flash[:warning] = t "admin.courses.delete_failure"
    end
    redirect_to admin_courses_path
  end

  private
  def course_params
    params.require(:course).permit :name, :description, :status, :start_date,
      :end_date, subject_courses_attributes: [:id, :subject_id, :course_id, :status,
      :_destroy], subjects_attributes: [:id, :name, :description, :_destroy,
      tasks_attributes: [:id, :name, :_destroy]],
      user_courses_attributes: [:id, :course_id, :user_id, :status,
      :supervisor, :_destroy]
  end

  def load_course
    @course = Course.find_by id: params[:id]
  end
end
