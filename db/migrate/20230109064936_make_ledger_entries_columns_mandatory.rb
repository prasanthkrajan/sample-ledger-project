class MakeLedgerEntriesColumnsMandatory < ActiveRecord::Migration[6.0]
  def up
    change_column :ledger_entries, :amount, :float, null: false
    change_column :ledger_entries, :currency, :string, null: false
    change_column :ledger_entries, :description, :text, null: false
  end

  def down
    change_column :ledger_entries, :amount, null: true
    change_column :ledger_entries, :currency, null: true
    change_column :ledger_entries, :description, null: true
  end
end
