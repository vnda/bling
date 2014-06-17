VndaBling::Application.routes.draw do
  root :to => 'shops#index'
  get :status, to: 'application#status'

  resources :shops, :except => [:show]

  post '/bling/:token', :to => 'bling#create', :as => "bling"
end
