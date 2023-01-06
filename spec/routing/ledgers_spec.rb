require "rails_helper"

RSpec.describe LedgersController, type: :routing do
  it 'routes to my_ledger when hit root path' do
    expect(get('/')).to route_to('ledgers#my_ledger')
  end

  it 'routes to my_ledger when hit /ledgers' do
    expect(get('/my_ledger')).to route_to('ledgers#my_ledger')
  end

  it 'does not support other generic routes' do
    expect(get('/ledgers')).not_to be_routable
    expect(get('/ledgers/new')).not_to be_routable
    expect(get('/ledgers/1')).not_to be_routable
    expect(post('/ledgers')).not_to be_routable
    expect(delete('/ledgers/1')).not_to be_routable
    expect(put('/ledgers/1')).not_to be_routable
    expect(patch('/ledgers/1')).not_to be_routable
  end
end