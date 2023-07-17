class ChangeDefaultInRestaurants < ActiveRecord::Migration[7.0]
  def change
    change_column_default :restaurants, :status, from: "0", to: "open"
  end
end
