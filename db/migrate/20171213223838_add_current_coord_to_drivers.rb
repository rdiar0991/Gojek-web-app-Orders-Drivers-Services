class AddCurrentCoordToDrivers < ActiveRecord::Migration[5.1]
  def change
    add_column :drivers, :current_coord, :string, default: "0.0, 0.0"
  end
end
