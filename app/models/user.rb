class User < ApplicationRecord
  VALIDATA_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: Settings.name_maximun}
  validates :password, length: {minimum: Settings.password_minimun}
  validates :email, presence: true, length: {maximum: Settings.email_maximun},
    format: {with: VALIDATA_EMAIL}, uniqueness: {case_sensitive: false}
  before_save :downcase_email
  has_secure_password

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  private

  def downcase_email
    email.downcase!
  end
end
