Rails.application.routes.draw do
  devise_for :users,
    path: "api/v1/auth",
    path_names: { sign_in: "sign_in", sign_out: "sign_out", registration: "sign_up" },
    controllers: {
      sessions:      "api/v1/auth/sessions",
      registrations: "api/v1/auth/registrations"
    }

  namespace :api do
    namespace :v1 do
      resources :rooms, only: [:index, :show, :create] do
        resources :transactions, only: [:index, :create, :update, :destroy]
        resources :invitations,  only: [:create]
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
