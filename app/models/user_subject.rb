class UserSubject < ActiveRecord::Base
  attr_accessor :user_id
  enum status: [:open, :started, :finished]
  belongs_to :user
  belongs_to :subject
  belongs_to :user_course

  has_many :user_tasks
  has_many :tasks, through: :user_tasks

  accepts_nested_attributes_for :user_tasks, reject_if: proc{|a| a[:task_id] == "0"}

  after_update :update_subject_status
  scope :has_user_with_course, ->(user, user_course) {
    where "user_id = ? AND user_course_id = ?", user.id, user_course.id
  }

  private
  def update_subject_status
    if user_tasks.count == subject.tasks.count && status != Settings.user_subject.status.finished
      update status: Settings.user_subject.status.finished
    end
  end
end
