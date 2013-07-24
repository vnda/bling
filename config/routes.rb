VndaBling::Application.routes.draw do
  root :to => 'shops#index'

  resources :shops

  post '/bling', :to => 'bling#create'

  get "/login", :to => "login#new", :as => :login
  post "/login", :to => "login#create"
  delete "/logout", :to => "login#destroy", :as => :logout
  get "/password", :to => "login#renew_password", :as => :renew_password
  post "/password", :to => "login#set_password"
end
