class ChangeBidStatusDefaultOnDrivers < ActiveRecord::Migration[5.1]
  def change
    change_column_default :drivers, :bid_status, from: "Not set", to: "N/A"
  end
end
