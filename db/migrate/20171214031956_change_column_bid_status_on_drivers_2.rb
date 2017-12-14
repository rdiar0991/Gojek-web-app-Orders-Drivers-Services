class ChangeColumnBidStatusOnDrivers2 < ActiveRecord::Migration[5.1]
  def change
    change_column :drivers, :bid_status, :string
    change_column_default :drivers, :bid_status, from: 0, to: "Not set"
  end
end
