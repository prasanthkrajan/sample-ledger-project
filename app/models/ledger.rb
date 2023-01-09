class Ledger < ApplicationRecord
	has_many :ledger_entries
	accepts_nested_attributes_for :ledger_entries 

	validates_presence_of :title
end
