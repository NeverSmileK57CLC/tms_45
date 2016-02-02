class UserSubjectsController < ApplicationController
  before_action :load_user_subject, only: [:show, :update]
  before_action :check_permission, only: [:show, :update]

  def show
    @subject = @user_subject.subject
    @tasks = @subject.tasks
    @tasks.each do |task|
      @user_subject.user_tasks.find_or_initialize_by user_id: @user_subject.user.id,
        task_id: task.id
    end
    @activities = Activity.get_activities current_user.id,
      Settings.target_type.task, @subject.id
  end

  def update
    @user_subject.user_id = current_user.id
    if params[:type]
      @user_subject.update_attributes status: params[:type].to_i
      redirect_to :back
    else
      if @user_subject.update_attributes user_subject_params
        flash[:success] = t "client.user_subject.finish_task_success"
      else
        flash[:warning] = t "client.user_subject.finish_task_fail"
      end
      redirect_to @user_subject
    end
  end

  private
  def load_user_subject
    @user_subject = UserSubject.find params[:id]
  end

  def user_subject_params
    params.require(:user_subject).permit :status, user_tasks_attributes: [:id, :user_id,
      :task_id]
  end

  def check_permission
    unless current_user.is_user?(@user_subject.user) && @user_subject.user_course.started?
      flash[:warning] = t "cannot_finish"
      redirect_to :back
    end
  end
end
