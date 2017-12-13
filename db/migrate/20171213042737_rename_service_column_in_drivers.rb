class RenameServiceColumnInDrivers < ActiveRecord::Migration[5.1]
  def change
    rename_column :drivers, :service, :go_service
  end
end
