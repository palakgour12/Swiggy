class AddColumnToDish < ActiveRecord::Migration[7.0]
  def change
    add_column :dishes, :image, :binary
  end
end
