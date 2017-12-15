class EditTypeOnOrders < ActiveRecord::Migration[5.1]
  def change
    rename_column :orders, :type, :service_type
  end
end
