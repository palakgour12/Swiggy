class AddColumnToCart < ActiveRecord::Migration[7.0]
  def change
    add_column :carts, :order_id, :string
  end
end
