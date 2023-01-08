require 'rails_helper'

RSpec.describe LedgerEntry, type: :model do
  it "belongs to ledger" do
    should respond_to(:ledger)
    t = LedgerEntry.reflect_on_association(:ledger)
    expect(t.macro).to eq(:belongs_to)
  end
end
