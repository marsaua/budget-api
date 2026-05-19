module Api
  module V1
    module Auth
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        before_action :configure_permitted_parameters

        protected

        # Prevent session write in API-only mode; JWT is dispatched by warden-jwt middleware
        def sign_up(resource_name, resource)
          sign_in(resource_name, resource, store: false)
        end

        private

        def configure_permitted_parameters
          devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
        end

        def respond_with(resource, _opts = {})
          if resource.persisted?
            render json: { user: serialize_user(resource) }, status: :created
          else
            render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def serialize_user(user)
          { id: user.id, email: user.email, name: user.name }
        end
      end
    end
  end
end
