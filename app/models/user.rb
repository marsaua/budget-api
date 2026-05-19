class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :memberships, dependent: :destroy
  has_many :rooms, through: :memberships
  has_many :owned_rooms, class_name: "Room", foreign_key: :owner_id, dependent: :destroy
  has_many :transactions, foreign_key: :author_id, dependent: :nullify

  validates :name, presence: true
end
