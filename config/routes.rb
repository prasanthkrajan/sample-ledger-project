Rails.application.routes.draw do
  root to: 'ledgers#my_ledger'
  get '/my_ledger', to: 'ledgers#my_ledger'
  post 'export', to: 'ledgers#export'
end
