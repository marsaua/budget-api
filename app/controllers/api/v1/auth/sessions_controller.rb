module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        respond_to :json

        # Prevent session write in API-only mode; JWT is dispatched by warden-jwt middleware
        def create
          self.resource = warden.authenticate!(auth_options)
          sign_in(resource_name, resource, store: false)
          respond_with resource
        end

        private

        def respond_with(resource, _opts = {})
          render json: { user: serialize_user(resource) }
        end

        def respond_to_on_destroy
          render json: { message: "Signed out successfully" }
        end

        def serialize_user(user)
          { id: user.id, email: user.email, name: user.name }
        end
      end
    end
  end
end
