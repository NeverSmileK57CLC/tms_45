class SubjectCourse < ActiveRecord::Base
  attr_accessor :user_id
  enum status: [:open, :started, :finished]

  belongs_to :subject
  belongs_to :course

  after_update :set_user_subject_status

  private
  def set_user_subject_status
    user_subjects = UserSubject.where subject_id: subject.id
    user_subjects.each do |user_subject|
      user_subject.update status: status
    end
  end
end
