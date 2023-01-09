FactoryBot.define do
  factory :ledger_entry do
    association :ledger
    amount      { 100.0 }
    currency    { 'USD' }
    description { 'some-description' }
    created_at  { DateTime.new(2023,01,01) }
  end
end