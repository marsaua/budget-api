class TransactionPolicy < ApplicationPolicy
  def create?  = room_member?
  def update?  = room_member?
  def destroy? = room_member?

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(room: :memberships).where(memberships: { user_id: user.id })
    end
  end

  private

  def room_member?
    record.room.memberships.exists?(user_id: user.id)
  end
end
