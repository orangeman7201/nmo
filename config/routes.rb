Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :conditions do
        collection do
          get 'up_to_date'
          get 'between_dates'
        end
      end
      resources :hospital_appointments
      resources :consultation_reports do
        member do
          post :generate_ai_summary
        end
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "csrf" => "csrf#show", as: :csrf

  # Defines the root path route ("/")
  # root "posts#index"
end
