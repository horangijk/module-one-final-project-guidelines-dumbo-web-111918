class AddDescriptionColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :electronics, :description, :text
  end
end
