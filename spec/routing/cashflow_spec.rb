require "rails_helper"

RSpec.describe CashflowController, type: :routing do
  it 'routes to index when hit root path' do
    expect(get('/')).to route_to('cashflow#index')
  end

  it 'routes to index when hit /cashflow' do
    expect(get('/cashflow')).to route_to('cashflow#index')
  end

  it 'does not support other generic routes' do
    expect(get('/cashflow/new')).not_to be_routable
    expect(get('/cashflow/1')).not_to be_routable
    expect(post('/cashflow')).not_to be_routable
    expect(delete('/cashflow/1')).not_to be_routable
    expect(put('/cashflow/1')).not_to be_routable
    expect(patch('/cashflow/1')).not_to be_routable
  end
end