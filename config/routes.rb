VndaBling::Application.routes.draw do
  root :to => 'bling#index'
  post '/bling', :to => 'orders#create'
end
