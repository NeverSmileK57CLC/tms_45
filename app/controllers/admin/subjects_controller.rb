class Admin::SubjectsController < Admin::AdminController
  before_action :load_subject, except: [:index, :new, :create]

  def index
    @subjects = Subject.paginate page: params[:page]
  end

  def show
    @tasks = @subject.tasks
  end

  def new
    @subject = Subject.new
    @subject.tasks.build
  end

  def create
    @subject = Subject.new subject_params
    if @subject.save
      flash[:success] = t "admin.flash.create_subject"
      redirect_to admin_subjects_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @subject.update_attributes subject_params
      flash[:success] = t "admin.flash.update_subject"
      redirect_to admin_subjects_path
    else
      render :edit
    end
  end

  def destroy
    if @subject.destroy
      flash[:success] = t "admin.flash.del_subject"
    else
      flash[:error] = t "admin.flash.del_failed"
    end
    redirect_to admin_subjects_path
  end

  private
  def subject_params
    params.require(:subject).permit :name, :description,
      tasks_attributes: [:id, :name, :_destroy]
  end

  def load_subject
    @subject = Subject.find params[:id]
  end
end
