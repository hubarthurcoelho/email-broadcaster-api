Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "up" => "rails/health#show", as: :rails_health_check

  resources :messages, only: [ :show, :create, :index ] do
    resources :message_receipts, only: [ :index ]
  end
end
