class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, length: { minimum: 6 }, if: -> { password.present? }

  has_many :compilations, dependent: :destroy

  before_create :generate_email_confirmation_token

  def generate_reset_token
    self.reset_token = SecureRandom.hex(32)
    self.reset_token_expires_at = 1.hour.from_now
    save
  end

  def reset_token_expired?
    reset_token_expires_at < Time.current
  end

  def clear_reset_token
    update(reset_token: nil, reset_token_expires_at: nil)
  end

  def generate_email_confirmation_token
    self.email_confirmation_token = SecureRandom.hex(32) if email_changed?
    self.email_confirmed_at = nil
  end

  def confirm_email_change(token)
    return false if email_confirmation_token != token
    return false if email_confirmation_token.nil?

    update(
      email: pending_email,
      pending_email: nil,
      email_confirmation_token: nil,
      email_confirmed_at: Time.current
    )
  end

  def initiate_email_change(new_email)
    return false if User.exists?(email: new_email)

    self.pending_email = new_email
    self.email_confirmation_token = SecureRandom.hex(32)
    save
  end
end
