class LedgerEntry < ApplicationRecord
  belongs_to :ledger
  validates_presence_of :amount, :currency, :description
end
