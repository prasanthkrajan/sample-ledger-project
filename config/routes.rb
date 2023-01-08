Rails.application.routes.draw do
  root to: 'ledgers#my_ledger'
  get '/my_ledger', to: 'ledgers#my_ledger'
  post 'export', to: 'ledgers#export'

  resources :ledgers, only: [:new, :create, :index, :show]
  resources :ledger_entries, only: [:new, :create, :index]
end
