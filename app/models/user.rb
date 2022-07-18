# frozen_string_literal: true

class User < ApplicationRecord
  has_many :user_viewing_parties
  has_many :viewing_parties, through: :user_viewing_parties
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  def self.other_users(id)
    User.where.not(id: id)
  end
end
