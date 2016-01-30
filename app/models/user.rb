class User < ActiveRecord::Base
  attr_accessor :remember_token, :reset_token

  enum role: [:admin, :trainee]

  has_many :user_subjects
  has_many :activities
  has_many :user_courses
  has_many :user_tasks

  before_save {self.email = email.downcase}
  before_update :check_password_empty

  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: 6, maximum: 30},
    allow_nil: true

  scope :excluded, ->(users) {where.not id: users}

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

    def list_by_role course_id, supervisor
      user_courses = "SELECT user_id FROM user_courses WHERE
        course_id = :course_id AND supervisor = :supervisor"
      where "id IN (#{user_courses})", course_id: course_id,
        supervisor: supervisor
    end

    def to_csv options = {}
      CSV.generate options do |csv|
        csv << column_names
        all.each do |user|
          csv << user.attributes.values_at(*column_names)
        end
      end
    end

    def search search
      search.present? ? where("lower(name) LIKE lower(:search) or lower(email)
        LIKE lower(:search)", search: "%#{search}%") : all
    end
  end

  def is_user? user
    self == user
  end

  def supervisor? course
    user_courses.where("course_id = ? AND supervisor = ?", course.id, true).present?
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

   def forget
    update_attributes remember_digest: nil
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attributes reset_digest: User.digest(reset_token)
    update_attributes reset_sent_at: Time.zone.now
  end

  def password_reset_expired? time
    reset_sent_at < time.hours.ago
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def check_password_empty
    if !password.nil? && password.empty?
      self.errors.add :password, I18n.t(:not_empty)
      return false
    end
  end
end
