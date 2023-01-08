class CreateLedgerEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :ledger_entries do |t|
      t.float :amount
      t.string :currency
      t.boolean :is_credit
      t.text :description
      t.references :ledger, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
