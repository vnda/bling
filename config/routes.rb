VndaBling::Application.routes.draw do
  root :to => 'shops#index'

  resources :shops, :except => [:show]

  post '/bling/:token', :to => 'bling#create', :as => "bling"
end
