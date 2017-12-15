class AddTypeToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :type, :string
  end
end
