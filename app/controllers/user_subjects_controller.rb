class UserSubjectsController < ApplicationController
  before_action :load_user_subject, only: [:show, :update]
  def show
    @subject = @user_subject.subject
    @tasks = @subject.tasks
    @tasks.each do |task|
      @user_subject.user_tasks.find_or_initialize_by user_id: @user_subject.user.id,
        task_id: task.id
    end
  end

  def update
    if @user_subject.update_attributes user_subject_params
      flash[:success] = t "client.user_subject.finish_task_success"
    else
      flash[:warning] = t "client.user_subject.finish_task_fail"
    end
    redirect_to @user_subject
  end

  private
  def load_user_subject
    @user_subject = UserSubject.find params[:id]
  end

  def user_subject_params
    params.require(:user_subject).permit user_tasks_attributes: [:id, :user_id,
      :task_id]
  end
end
