class AddPriceColumnToElectronics < ActiveRecord::Migration[5.0]
  def change
    add_column :electronics, :price, :float
  end
end
