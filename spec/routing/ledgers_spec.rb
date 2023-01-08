require "rails_helper"

RSpec.describe LedgersController, type: :routing do
  it 'routes to my_ledger when hit root path' do
    expect(get('/')).to route_to({controller: 'ledgers', action: 'my_ledger'})
  end

  it 'routes to my_ledger when hit /ledgers' do
    expect(get('/my_ledger')).to route_to({controller: 'ledgers', action: 'my_ledger'})
  end

  it 'routes to export when post to /export' do
    expect(post('/export')).to route_to({controller: 'ledgers', action: 'export'})
  end

  it 'routes to supported generic routes' do
    expect(get('/ledgers/new')).to route_to({controller: 'ledgers', action: 'new'})
    expect(post('/ledgers')).to route_to({controller: 'ledgers', action: 'create'})
    expect(get('/ledgers')).to route_to({controller: 'ledgers', action: 'index'})
    expect(get('/ledgers/1')).to route_to({controller: 'ledgers', action: 'show', id: '1'})
  end

  it 'does not support other generic routes' do
    expect(get('/export')).not_to be_routable
    expect(delete('/ledgers/1')).not_to be_routable
    expect(put('/ledgers/1')).not_to be_routable
    expect(patch('/ledgers/1')).not_to be_routable
  end
end