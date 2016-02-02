class UserCourse < ActiveRecord::Base
  enum status: [:open, :started, :finished]

  belongs_to :user
  belongs_to :course
  has_many :user_subjects, dependent: :destroy

  before_create {self.status = course.status}
  before_create :set_unique_active
  after_create :create_user_subjects
  after_create :set_user_subject_status

  scope :joined_by, ->(user) {where user_id: user.id}
  scope :joined_as_trainee, ->(user) {where "user_id = ? AND supervisor = ?",
    user.id, false}

  class << self
    def build_users added_users, course
      users = User.trainee
      users.each do |user|
        course.user_courses.build user_id: user.id unless
          added_users.include? user
      end
    end
  end

  private
  def set_unique_active
    UserCourse.where(user_id: user_id).each do |user_course|
      user_course.status = Settings.user_subject.status.default_status if user_course.started?
      user_course.save
    end
    status = Settings.user_subject.status.status_start
  end

  def create_user_subjects
    if course.subjects.present?
      course.subjects.each do |subject|
        user_subjects.create user: user, subject: subject, status: status
      end
    end
  end

  def set_user_subject_status
    user_subjects.each do |user_subject|
      subject_course = course.subject_courses.find_by subject_id: user_subject.subject.id
      user_subject.update status: subject_course.status
    end
  end
end
