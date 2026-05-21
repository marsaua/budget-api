module Api
  module V1
    class MembershipsController < ApplicationController
      before_action :set_room

      def index
        authorize @room, :show?
        memberships = @room.memberships.includes(:user)

        render json: memberships.map { |m| serialize_member(m) }
      end

      def destroy
        membership = @room.memberships.find(params[:id])
        authorize membership
        membership.destroy
        head :no_content
      end

      private

      def set_room
        @room = current_user.rooms.find(params[:room_id])
      end

      def serialize_member(m)
        room_txns = @room.transactions.where(author_id: m.user_id)
        total_expense = room_txns.where(kind: "expense").sum(:amount).to_f.round(2)
        total_income  = room_txns.where(kind: "income").sum(:amount).to_f.round(2)

        {
          id:            m.id,
          user_id:       m.user_id,
          name:          m.user.name,
          role:          m.role,
          total_expense: total_expense,
          total_income:  total_income
        }
      end
    end
  end
end
