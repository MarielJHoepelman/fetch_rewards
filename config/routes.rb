Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/points/add', to: 'points#add', as:'add'
  post '/points/spend', to: 'points#spend', as:'spend'
  get '/points/balance', to: 'points#balance', as:'balance'
end
