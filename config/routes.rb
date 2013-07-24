VndaBling::Application.routes.draw do
  root :to => 'bling#index'
  post '/bling', :to => 'bling#create'
end
