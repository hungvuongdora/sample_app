class User < ApplicationRecord
  VALIDATA_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  attr_reader :remember_token
  attr_reader :activation_token
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

  def authenticated? remember_token
    return false unless remember_digest
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update remember_digest: nil
  end

  def current_user? user
    self == user
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
