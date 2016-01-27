class Admin::CoursesController < Admin::AdminController
  before_action :load_course, only: [:show, :edit, :update, :destroy]

  def index
    @courses = Course.paginate page: params[:page]
  end

  def new
    @course = Course.new
    @course.build_subject_courses
  end

  def create
    status = params[:course][:status]
    params[:course][:status] = status.to_i if status.present?
    @course = Course.new course_params
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
    if params[:type]
      @course.update_attributes status: params[:type].to_i
      redirect_to :back
    else
      status = params[:course][:status]
      params[:course][:status] = status.to_i if status.present?
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
      tasks_attributes: [:id, :name]],
      user_courses_attributes: [:id, :course_id, :user_id, :status,
      :supervisor, :_destroy]
  end

  def load_course
    @course = Course.find_by id: params[:id]
  end
end
