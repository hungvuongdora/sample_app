class User < ApplicationRecord
  VALIDATA_EMAIL = /\A[a-zA-Z0-9]+@[a-zA-Z]+\.[a-zA-Z]+(\.[a-zA-Z]+)*\z/
  validate :name, presence: true, length: {Settings.name_maximun}
  validate :password_digest, presence: true, length: {Settings.password_digest_minimun}
  validate :gmail, presence: true, length: {Settings.email_maximun},
    format: {with: VALIDATA_EMAIL}, uniqueness: {case_sensitive: false}
  before_save :downcase_email
  has_secure_password

  private

  def downcase_email
    email.downcase!
  end

end
