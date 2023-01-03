Rails.application.routes.draw do
  root to: 'ledgers#index'
  
  resources :ledgers, only: :index
end
