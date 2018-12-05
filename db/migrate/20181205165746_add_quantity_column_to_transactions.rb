class AddQuantityColumnToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :quantity, :integer
  end
end
