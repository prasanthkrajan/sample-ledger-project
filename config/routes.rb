Rails.application.routes.draw do
  root to: 'cashflow#index'
  
  resources :cashflow, only: :index
end
