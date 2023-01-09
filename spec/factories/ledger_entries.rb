FactoryBot.define do
  factory :ledger_entry do
    association :ledger
    amount { 100.0 }
    currency { 'USD' }
    description { 'some-description' }
  end
end