require 'rails_helper'

RSpec.describe Ledger, type: :model do
  it 'is not valid without a title' do
    ledger = Ledger.new(title: nil)
    expect(ledger).to_not be_valid
  end

  it "has many ledger entries" do
    should respond_to(:ledger_entries)
  end
end
