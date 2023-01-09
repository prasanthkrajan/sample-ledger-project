require 'rails_helper'

RSpec.describe LedgerEntry, type: :model do
  it "belongs to ledger" do
    should respond_to(:ledger)
    t = LedgerEntry.reflect_on_association(:ledger)
    expect(t.macro).to eq(:belongs_to)
  end

  it 'is not valid without an amount' do
    ledger_entry = LedgerEntry.new(amount: nil)
    expect(ledger_entry).to_not be_valid
  end

  it 'is not valid without a currency' do
    ledger_entry = LedgerEntry.new(currency: nil)
    expect(ledger_entry).to_not be_valid
  end

  it 'is not valid without a description' do
    ledger_entry = LedgerEntry.new(description: nil)
    expect(ledger_entry).to_not be_valid
  end
end
