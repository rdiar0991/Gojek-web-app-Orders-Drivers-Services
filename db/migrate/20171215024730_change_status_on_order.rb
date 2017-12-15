class ChangeStatusOnOrder < ActiveRecord::Migration[5.1]
  def change
    change_column :orders, :status, :integer
    change_column_default :orders, :status, to: 0
  end
end
