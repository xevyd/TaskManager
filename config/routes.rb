Rails.application.routes.draw do
  default_url_options :host => "localhost:3000"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  root :to => "web/boards#show"
  
  scope module: :web do
    resource :board, only: :show
    resource :session, only: [:new, :create, :destroy]
    resources :developers, only: [:new, :create]
    resource :password, only: [:new, :create, :edit, :update]
  end

  namespace :admin do
    resources :users
  end

  namespace :api do
    namespace :v1 do
      resources :tasks, only: [:index, :show, :create, :update, :destroy] do
        member do
          put :attach_image
          delete :remove_image
        end
      end
      resources :users, only: [:index, :show]
    end
  end
end
