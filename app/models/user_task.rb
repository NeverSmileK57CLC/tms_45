class UserTask < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  belongs_to :user_subject

  scope :has_task, ->(target_user, target_task) {
    where user_id: target_user.id, task_id: target_task.id}
end
