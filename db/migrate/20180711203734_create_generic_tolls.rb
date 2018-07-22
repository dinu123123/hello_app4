class CreateGenericTolls < ActiveRecord::Migration[5.1]
  def change
    create_table :generic_tolls do |t|
      t.date :StartDate
      t.date :EndDate
      t.decimal :Km
      t.decimal :EUR
      t.integer :truck_id
      t.string :country

      t.timestamps
    end
  end
end
