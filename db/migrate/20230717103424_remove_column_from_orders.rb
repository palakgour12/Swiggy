class RemoveColumnFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :cart_id, :integer
  
  end
end
