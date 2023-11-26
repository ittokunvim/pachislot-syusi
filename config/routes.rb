Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "static_pages#home"

  get "/hello", to: "hello#index"

  resources :blances, path: "/syusi" do
    get "/history", to: "histories#index", as: :index_history
    resources :histories, only: %i[edit create update destroy]
  end
end
