module Api
  module V1
    class InvitationsController < ApplicationController
      def create
        room = current_user.rooms.find(params[:room_id])
        authorize room, :invite?

        invitee = User.find_by!(email: invitation_params[:email])

        if room.members.include?(invitee)
          return render json: { error: "User is already a member" }, status: :unprocessable_entity
        end

        room.memberships.create!(user: invitee, role: :member)
        render json: { message: "#{invitee.name} added to #{room.name}" }, status: :created
      end

      private

      def invitation_params
        params.require(:invitation).permit(:email)
      end
    end
  end
end
