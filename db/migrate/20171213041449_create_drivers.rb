class CreateDrivers < ActiveRecord::Migration[5.1]
  def change
    create_table :drivers do |t|
      t.string :name
      t.string :email, index: true, unique: true
      t.string :phone
      t.string :password_digest
      t.decimal :gopay_balance, precision: 8, scale: 2, null: false, default: 0.0
      t.boolean :bid_status, default: false
      t.string :current_location, default: nil
      t.string :service

      t.timestamps
    end
  end
end
