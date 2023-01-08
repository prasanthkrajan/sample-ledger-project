require "rails_helper"

RSpec.describe LedgerEntriesController, type: :routing do
  it 'routes to supported generic routes' do
    expect(get('/ledger_entries/new')).to route_to({controller: 'ledger_entries', action: 'new'})
    expect(post('/ledger_entries')).to route_to({controller: 'ledger_entries', action: 'create'})
    expect(get('/ledger_entries')).to route_to({controller: 'ledger_entries', action: 'index'})
  end

  it 'does not support other generic routes' do
    expect(delete('/ledger_entries/1')).not_to be_routable
    expect(get('/ledger_entries/1')).not_to be_routable
    expect(put('/ledger_entries/1')).not_to be_routable
    expect(patch('/ledger_entries/1')).not_to be_routable
  end
end