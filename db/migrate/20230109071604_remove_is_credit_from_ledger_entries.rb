class RemoveIsCreditFromLedgerEntries < ActiveRecord::Migration[6.0]
  def up
    remove_column :ledger_entries, :is_credit, :boolean
  end

  def down
    add_column :ledger_entries, :is_credit, :boolean
  end
end
