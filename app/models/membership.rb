class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :room

  enum :role, { member: "member", owner: "owner" }

  validates :role, inclusion: { in: roles.keys }
  validates :user_id, uniqueness: { scope: :room_id }
end
