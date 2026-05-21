class MembershipPolicy < ApplicationPolicy
  def index?
    RoomPolicy.new(user, record.room).show?
  end

  def destroy?
    record.room.owner_id == user.id && record.role != "owner"
  end
end
