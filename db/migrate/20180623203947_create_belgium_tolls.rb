class CreateBelgiumTolls < ActiveRecord::Migration[5.1]
  def change
    create_table :belgium_tolls do |t|
      t.date :StartDate
      t.time :StartTime
      t.date :EndDate
      t.time :EndTime
      t.decimal :Km
      t.decimal :EUR
      t.integer :truck_id
      t.timestamps
    end
  end
end
