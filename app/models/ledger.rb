class Ledger < ApplicationRecord
	has_many :ledger_entries
	validates_presence_of :title
end
