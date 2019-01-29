class User < ApplicationRecord
  VALIDATA_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  attr_reader :remember_token, :activation_token, :reset_token

  validates :name, presence: true, length: {maximum: Settings.name_maximun}
  validates :password, length: {minimum: Settings.password_minimun},
    allow_nil: true
  validates :email, presence: true, length: {maximum: Settings.email_maximun},
    format: {with: VALIDATA_EMAIL}, uniqueness: {case_sensitive: false}

  before_save :downcase_email
  before_create :create_activation_digest
  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    @remember_token = User.new_token
    update remember_digest: User.digest(@remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"

    return false unless digest
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update remember_digest: nil
  end

  def current_user? user
    self == user
  end

  def activate
    update activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    @reset_token = User.new_token
    update reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.expired_time_reset_password.hours.ago
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    @activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
