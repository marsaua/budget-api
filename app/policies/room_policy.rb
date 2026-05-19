class RoomPolicy < ApplicationPolicy
  def show?   = member?
  def create? = true
  def update? = owner?
  def destroy? = owner?
  def invite? = member?

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:memberships).where(memberships: { user_id: user.id })
    end
  end

  private

  def member?
    record.memberships.exists?(user_id: user.id)
  end

  def owner?
    record.owner_id == user.id
  end
end
