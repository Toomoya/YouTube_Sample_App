Rails.application.routes.draw do

  root 'youtube#index'
  resources :youtube, :only => [:index, :show, :create]
end
