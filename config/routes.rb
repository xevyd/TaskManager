Rails.application.routes.draw do
  root :to => "web/boards#show"
  
  scope module: :web do
    resource :board, only: :show
    resource :session, only: [:new, :create, :destroy]
    resource :developers, only: [:new, :create]
  end
end
