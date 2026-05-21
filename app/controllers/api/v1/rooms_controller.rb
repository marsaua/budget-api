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

      before_action :set_room_for_mutation, only: [:update, :destroy]

      def update
        authorize @room
        if @room.update(room_params)
          render json: serialize(@room)
        else
          render json: { errors: @room.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @room
        @room.destroy
        head :no_content
      end

      private

      def set_room_for_mutation
        @room = Room.find(params[:id])
      end

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
