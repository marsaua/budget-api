module Api
  module V1
    class RoomsController < ApplicationController
      def index
        rooms = policy_scope(Room)
        render json: rooms.map { |r| serialize(r) }
      end

      def show
        room = find_room
        authorize room
        render json: serialize(room)
      end

      def create
        room = Room.new(room_params.merge(owner: current_user))
        authorize room
        if room.save
          render json: serialize(room), status: :created
        else
          render json: { errors: room.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def find_room
        current_user.rooms.find(params[:id])
      end

      def room_params
        params.require(:room).permit(:name)
      end

      def serialize(room)
        {
          id: room.id,
          name: room.name,
          owner_id: room.owner_id,
          members_count: room.members.count
        }
      end
    end
  end
end
