class CreateFuelExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :fuel_expenses do |t|
      t.time :trstime
      t.date :trsdate
      t.string :product
      t.decimal :volume
      t.decimal :eurnetamount
      t.integer :kminsertion
      t.string :platenr
      t.string :cardnr
      t.integer :stationid
      t.string :stationname
      t.decimal :eurgrossunitprice
      t.decimal :eurgrossamount
      t.string :country
      t.integer :truck_id
      t.timestamps
    end
  end
end
