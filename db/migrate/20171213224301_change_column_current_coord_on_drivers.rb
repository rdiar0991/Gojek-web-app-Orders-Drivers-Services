class ChangeColumnCurrentCoordOnDrivers < ActiveRecord::Migration[5.1]
  def change
    change_column_default :drivers, :current_coord, from: "0.0, 0.0", to: "N/A"
  end
end
