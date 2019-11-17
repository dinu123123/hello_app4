class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.date :date
      t.integer :DRIVER_id
      t.integer :truck_id
      t.integer :trailer_id
      t.integer :client_id
      t.integer :driver_expense_id
      t.integer :truck_expense_id
      t.text :start_address
      t.text :dest_addresses
      t.integer :volume
      t.text :tank
      t.text :comments

      t.timestamps
    end
  end
end
