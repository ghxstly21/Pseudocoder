class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
    validates :name, presence: true

  validates :password, length: { minimum: 6 }
has_many :compilations, dependent: :destroy
end
