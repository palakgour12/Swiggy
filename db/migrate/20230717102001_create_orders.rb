class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :cart_id
      t.references :carts, null: false, foreign_key: true

      t.timestamps
    end
  end
end
