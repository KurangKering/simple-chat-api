class User < ApplicationRecord
  include BCrypt

  self.primary_key = :id_user

  validates :name, :email, :phone_number, :password, presence: true
  validates :email, email: true, uniqueness: true

  def self.generate_password(plain_password)
    Password.create(plain_password) unless plain_password.strip.empty?
  end
end
