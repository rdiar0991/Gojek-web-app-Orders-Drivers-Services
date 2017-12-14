class ChangeColumnCurrentLocationOnDrivers < ActiveRecord::Migration[5.1]
  def change
    change_column :drivers, :current_location, :text
    change_column_default :drivers, :current_location, from: nil, to: "N/A"
  end
end
