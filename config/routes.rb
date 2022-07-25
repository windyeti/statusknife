Rails.application.routes.draw do
  root to: "products#index"
  devise_for :users, controllers: {registrations: "registrations"}

  resources :products do
    collection do
      get :dpo_update
      get :import_insales_xml
      # get :create_csv_price
      # get :create_csv_quantity
      get :api_insales_update
    end
  end

  mount ActionCable.server => '/cable'
end
