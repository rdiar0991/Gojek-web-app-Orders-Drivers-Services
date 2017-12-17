class ChangeDefaultLocationAndCoordOnDrivers < ActiveRecord::Migration[5.1]
  def change
    change_column_default :drivers, :current_location, { from: "N/A", to: nil }
    change_column_default :drivers, :current_coord, { from: "", to: nil }
  end
end
