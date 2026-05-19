class Room < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :transactions, dependent: :destroy

  validates :name, presence: true

  after_create :add_owner_as_member

  private

  def add_owner_as_member
    memberships.create!(user: owner, role: :owner)
  end
end
