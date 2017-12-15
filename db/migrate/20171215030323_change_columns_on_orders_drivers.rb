class ChangeColumnsOnOrdersDrivers < ActiveRecord::Migration[5.1]
  def change
    change_column :orders, :payment_type, :integer
    change_column :drivers, :go_service, :integer
    change_column :drivers, :bid_status, :integer
  end
end
