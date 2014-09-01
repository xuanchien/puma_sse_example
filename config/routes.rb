Rails.application.routes.draw do
  root to: 'home#index'
  get '/check', to: 'home#check'
end
