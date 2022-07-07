Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "registrations"}
  root to: "dashboards#index"
end