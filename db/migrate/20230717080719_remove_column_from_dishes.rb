class RemoveColumnFromDishes < ActiveRecord::Migration[7.0]
  def change
    remove_column :dishes, :image, :binary
  end
end
