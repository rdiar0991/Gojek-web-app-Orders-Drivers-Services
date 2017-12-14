class ChangeColumnBidStatusOnDrivers < ActiveRecord::Migration[5.1]
  def change
    change_column :drivers, :bid_status, :integer
  end
end
